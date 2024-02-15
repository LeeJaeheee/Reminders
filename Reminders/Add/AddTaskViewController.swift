//
//  AddTaskViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit
import RealmSwift

class AddTaskViewController: BaseCustomViewController<AddTaskView> {
    
    var deadline: Date?
    var tag: String?
    var priority: Int?

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
    }
    
    @objc func leftBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonTapped() {
        // DB에 저장
        let cell = mainView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MemoTableViewCell
        if let title = cell.titleTextField.text, !title.isEmpty, let deadline, let priority, let tag {
            
            let realm = try! Realm()
            print(realm.configuration.fileURL)
            
            let memo = cell.memoTextView.text.isEmpty ? cell.memoTextView.text : nil
            let data = TaskTable(title: title, memo: memo, deadline: deadline, tag: tag, priority: priority)
            
            try! realm.write {
                realm.add(data)
                print("Realm Create")
            }
            dismiss(animated: true)
        } else {
            showAlert(title: "ㅇㅇ", message: "ㅇㅇㅇㅇ")
        }
    }
    
    @objc func deadlineReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?[AddTask.deadline] as? Date {
            deadline = value
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            mainView.tableView.cellForRow(at: IndexPath(row: 0, section: AddTask.deadline.rawValue))?.detailTextLabel?.text = dateFormatter.string(from: value)
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
                self.tag = $0.isEmpty ? $0 : nil
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = $0
            }
            navigationController?.pushViewController(vc, animated: true)
        case .priority:
            let vc = PriorityViewController()
            vc.selectedIndex = {
                self.priority = $0
                tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = Priority(rawValue: $0)?.title
            }
            navigationController?.pushViewController(vc, animated: true)
        case .image:
            break
        }
    }
    
}
