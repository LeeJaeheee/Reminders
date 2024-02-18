//
//  AddTaskViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit
import Toast

// TODO: 값전달
class AddTaskViewController: BaseCustomViewController<AddTaskView> {
    
    var handler: ((Bool) -> Void)?
    
    var deadline: Date?
    var tag: String?
    var priority: Int?
    
    let repository = TaskTableRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(deadlineReceivedNotification), name: NSNotification.Name(AddTask.deadline.notiName), object: nil)
    }
    
    override func configureView() {
        navigationItem.title = "새로운 할 일"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        navigationController?.presentationController?.delegate = self
    }
    
    @objc func leftBarButtonTapped() {
        showAlertForDismiss()
    }
    
    @objc func rightBarButtonTapped() {
 
        view.endEditing(true)
        
        let cell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MemoTableViewCell
        
        guard let title = cell.titleTextField.text, !title.isEmpty else {
            view.makeToast("제목을 입력해주세요")
            return
        }
        
        guard let deadline = deadline else {
            view.makeToast("마감일을 입력해주세요")
            return
        }
        
        guard let tag = tag else {
            view.makeToast("태그를 입력해주세요")
            return
        }
        
        guard let priority = priority else {
            view.makeToast("우선순위를 선택해주세요")
            return
        }
        
        let memo = !cell.memoTextView.text.isEmpty ? cell.memoTextView.text : nil
        let data = TaskTable(title: title, memo: memo, deadline: deadline, tag: tag, priority: priority)
        
        repository.createItem(data)
        print(repository.getFileURL())
        
        handler?(true)
        dismiss(animated: true)

    }
    
    @objc func deadlineReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?[AddTask.deadline] as? Date {
            deadline = value
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            mainView.tableView.cellForRow(at: IndexPath(row: 0, section: AddTask.deadline.rawValue))?.detailTextLabel?.text = dateFormatter.string(from: value)
        }
    }
    
    func showAlertForDismiss() {
        showAlert(style: .actionSheet, okTitle: "변경사항 폐기", okStyle: .destructive, showCancelButton: true) {
            self.dismiss(animated: true)
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
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
            cell.textLabel?.text = AddTask(rawValue: indexPath.section)?.title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch AddTask(rawValue: indexPath.section)! {
        case .memo:
            break
        case .deadline:
            transition(style: .push, viewController: DeadlineViewController.self)
        case .tag:
            let vc = TagViewController()
            vc.tagText = {
                self.tag = !$0.isEmpty ? $0 : nil
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = $0
            }
            transition(style: .push, viewController: vc)
        case .priority:
            let vc = PriorityViewController()
            vc.selectedIndex = {
                self.priority = $0
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = Priority(rawValue: $0)?.title
            }
            transition(style: .push, viewController: vc)
        case .image:
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
