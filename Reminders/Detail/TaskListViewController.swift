//
//  TaskListViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/16/24.
//

import UIKit

class TaskListViewController: BaseViewController {
    
    let tableView = UITableView()
    
    let repository = TaskTableRepository()
    
    lazy var list = repository.fetch(.all)

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
        tableView.allowsMultipleSelectionDuringEditing = true
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
        
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button), editButton]
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {

        if tableView.isEditing, let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                repository.updateIsDone(list[indexPath.row])
            }
        }

        tableView.isEditing.toggle()
        
        sender.title = tableView.isEditing ? "완료" : "편집"
        navigationItem.rightBarButtonItems?[0].isHidden.toggle()
        
        tableView.reloadData()
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
        cell.selectionStyle = tableView.isEditing ? .default : .none
        
        if tableView.isEditing && data.isDone {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailAction = UIContextualAction(style: .normal, title: "세부사항") { _, _, completion in
            //TODO: 디테일 페이지 연결
            completion(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            self.repository.delete(self.list[indexPath.row])
            tableView.reloadData()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            print(indexPath)
        }
    }
    
}
