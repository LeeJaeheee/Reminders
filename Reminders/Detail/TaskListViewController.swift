//
//  TaskListViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/16/24.
//

import UIKit

class TaskListViewController: BaseViewController {
    
    let tableView = UITableView()
    
    let list = HomeCollection.all.database

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        navigationItem.title = "전체 할 일 목록"
        setBarButton()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setBarButton() {
        
        let items = UIMenu(title: "정렬 기준", options: [.singleSelection, .displayInline], children: [
            UIAction(title: "마감일", state: .on, handler: { _ in }),
            UIAction(title: "제목", handler: { _ in }),
            UIAction(title: "우선순위", handler: { _ in })
        ])
        
        let sortType = UIMenu(title: "정렬 순서", options: [.singleSelection, .displayInline], children: [
            UIAction(title: "오름차순", state: .on, handler: { _ in }),
            UIAction(title: "내림차순", handler: { _ in })
        ])
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.menu = UIMenu(children: [items, sortType])
        button.showsMenuAsPrimaryAction = true
        //button.changesSelectionAsPrimaryAction = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ListCell")
        
        let data = list[indexPath.row]
        cell.accessoryType = data.isDone ? .checkmark : .none
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = data.memo
        
        return cell
    }
    
}
