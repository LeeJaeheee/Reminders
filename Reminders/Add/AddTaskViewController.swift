//
//  AddTaskViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit
import Toast

// TODO: Flag 속성..
final class AddTaskViewController: BaseCustomViewController<AddTaskView> {
    
    private let repository = TaskTableRepository()
    
    private var deadline: Date?
    private var tag: String?
    private var priority: Int?
    private var image: UIImage?
    private var folder: Folder?
    
    var handler: (() -> Void)?
    
    var data: TaskTable?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(deadlineReceivedNotification), name: NSNotification.Name(AddTask.deadline.notiName), object: nil)
    }
    
    override func configureView() {
        navigationItem.title = data == nil ? "새로운 할 일" : "세부 사항"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: data == nil ? "추가" : "완료", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        navigationController?.presentationController?.delegate = self
    }
    
    @objc private func leftBarButtonTapped() {
        showAlertForDismiss()
    }
    
    @objc private func rightBarButtonTapped() {
 
        view.endEditing(true)
        
        let cell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MemoTableViewCell
        
        guard let title = cell.titleTextField.text, !title.isEmpty else { view.makeToast("제목을 입력해주세요"); return }
        guard let deadline = deadline else { view.makeToast("마감일을 입력해주세요"); return }
        guard let tag = tag else { view.makeToast("태그를 입력해주세요"); return }
        guard let priority = priority else { view.makeToast("우선순위를 선택해주세요"); return }
        guard let folder = folder else { view.makeToast("목록을 선택해주세요"); return }
        
        let memo = !cell.memoTextView.text.isEmpty ? cell.memoTextView.text : nil
        let newData = TaskTable(title: title, memo: memo, deadline: deadline, tag: tag, priority: priority)
        
        if let data {
            repository.update(data, newItem: newData, folder: folder)
        } else {
            repository.appendTask(folder: folder, item: newData)
        }
        
        if let image {
            saveImageToDocument(image, filename: "\(data?.id ?? newData.id)")
        }
        
        handler?()
        dismiss(animated: true)

    }
    
    @objc private func deadlineReceivedNotification(notification: NSNotification) {
        let taskDeadline = AddTask.deadline
        if let value = notification.userInfo?[taskDeadline] as? Date {
            deadline = value
            mainView.tableView.cellForRow(at: IndexPath(row: 0, section: taskDeadline.rawValue))?.detailTextLabel?.text = DateFormatter.displayString(from: value)
        }
    }
    
}

extension AddTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddTask.allCases.count
    }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as! MemoTableViewCell
            cell.selectionStyle = .none
            cell.titleTextField.text = data?.title
            cell.memoTextView.text = data?.memo
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
            cell.textLabel?.text = AddTask(rawValue: indexPath.section)?.title
            cell.accessoryType = .disclosureIndicator
            
            if let data = data {
                switch AddTask.allCases[indexPath.section] {
                case .memo:
                    break
                case .deadline:
                    deadline = data.deadline
                    cell.detailTextLabel?.text = DateFormatter.displayString(from: data.deadline)
                case .tag:
                    tag = data.tag
                    cell.detailTextLabel?.text = data.tag
                case .priority:
                    priority = data.priority
                    cell.detailTextLabel?.text = Priority(rawValue: data.priority)?.title
                case .image:
                    if let image = loadImageFromDocument(filename: "\(data.id)") {
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
                        imageView.image = image
                        cell.accessoryView = imageView
                    }
                case .folder:
                    folder = data.parent.first
                    cell.detailTextLabel?.text = folder?.title
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch AddTask(rawValue: indexPath.section)! {
        case .memo:
            break
        case .deadline:
            let vc = DeadlineViewController()
            vc.deadline = deadline
            transition(style: .push, viewController: vc)
        case .tag:
            let vc = TagViewController()
            vc.tag = tag
            vc.tagText = {
                self.tag = !$0.isEmpty ? $0 : nil
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = $0
            }
            transition(style: .push, viewController: vc)
        case .priority:
            let vc = PriorityViewController()
            vc.priority = priority
            vc.selectedIndex = {
                self.priority = $0
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = Priority(rawValue: $0)?.title
            }
            transition(style: .push, viewController: vc)
        case .image:
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        case .folder:
            let vc = FolderViewController()
            vc.folder = folder
            vc.handler = {
                self.folder = $0
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = $0.title
            }
            transition(style: .push, viewController: vc)
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

extension AddTaskViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        showAlertForDismiss()
        return false
    }
 
}

extension AddTaskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = pickedImage
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
            imageView.image = image
            mainView.tableView.cellForRow(at: IndexPath(row: 0, section: AddTask.image.rawValue))?.accessoryView = imageView
        }
        dismiss(animated: true)
    }
    
}
