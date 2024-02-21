//
//  TaskListViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/16/24.
//

import UIKit

final class TaskListViewController: BaseViewController {
    
    private let repository = TaskTableRepository()
    
    var collectionType = HomeCollection.all
    var sortParam = SortType.deadline(ascending: true).sortParam {
        didSet {
            list = repository.fetch(collectionType, sortParam: sortParam)
            tableView.reloadData()
        }
    }
    
    let tableView = UITableView()
    
    lazy var navTitle = collectionType.title
    lazy var list = repository.fetch(collectionType)
    
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
        
        navigationItem.title = navTitle
        setBarButton()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.identifier)
    }
    
    private func setBarButton() {
        
        let items = UIMenu(title: "정렬 기준", options: [.singleSelection, .displayInline], children: [
            UIAction(title: "마감일", state: .on, handler: { _ in
                self.sortParam = SortType.deadline(ascending: self.sortParam.ascending).sortParam
            }),
            UIAction(title: "제목", handler: { _ in
                self.sortParam = SortType.title(ascending: self.sortParam.ascending).sortParam
            }),
            UIAction(title: "우선순위", handler: { _ in
                self.sortParam = SortType.priority(ascending: self.sortParam.ascending).sortParam
            })
        ])
        
        let sortType = UIMenu(title: "정렬 순서", options: [.singleSelection, .displayInline], children: [
            UIAction(title: "오름차순", state: .on, handler: { _ in
                self.sortParam.ascending = true
            }),
            UIAction(title: "내림차순", handler: { _ in
                self.sortParam.ascending = false
            })
        ])
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.menu = UIMenu(children: [items, sortType])
        button.showsMenuAsPrimaryAction = true
        //button.changesSelectionAsPrimaryAction = true
        
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button), editButton]
    }
    
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {

        if tableView.isEditing, let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let item = list[indexPath.row]
                if !item.isDone {
                    repository.updateIsDone(item)
                }
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

        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.identifier, for: indexPath) as! TaskListTableViewCell
        
        let data = list[indexPath.row]
        cell.customImageView.image = loadImageFromDocument(filename: "\(data.id)")
        cell.configureCell(data)
        
        cell.selectionStyle = tableView.isEditing ? .default : .none
        
        if tableView.isEditing && data.isDone {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailAction = UIContextualAction(style: .normal, title: "세부사항") { _, _, completion in
            let vc = AddTaskViewController()
            vc.data = self.list[indexPath.row]
            vc.handler = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            self.transition(style: .presentNavigation, viewController: vc)
            completion(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            self.removeImageFromDocument(filename: "\(self.list[indexPath.row].id)")
            self.repository.delete(self.list[indexPath.row])
            tableView.reloadData()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let item = list[indexPath.row]
        if item.isDone {
            repository.updateIsDone(item)
        }
        return indexPath
    }
    
}
