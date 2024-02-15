//
//  AddTaskViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

class AddTaskViewController: BaseCustomViewController<AddTaskView> {
    
    var dateString: String = ""

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
        
    }
    
    @objc func rightBarButtonTapped() {
        
    }
    
    @objc func deadlineReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?[AddTask.deadline] as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateString = dateFormatter.string(from: value)
            mainView.tableView.reloadData() //왜안되지...
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
        cell.textLabel?.text = AddTask(rawValue: indexPath.section)?.title
        cell.detailTextLabel?.text = dateString
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch AddTask(rawValue: indexPath.section)! {
        case .memo:
            break
        case .deadline:
            transition(style: .push, viewController: DeadlineViewController.self)
        case .tag:
            transition(style: .push, viewController: TagViewController.self)
        case .priority:
            transition(style: .push, viewController: PriorityViewController.self)
        case .image:
            break
        }
    }
    
}
