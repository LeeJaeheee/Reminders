//
//  HomeViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit
import RealmSwift

protocol HomeViewDelegate {
    func leftBarButtonTapped()
    func rightBarButtonTapped()
}

// TODO: HomeVC -> TaskListVC -> AddTaskVC 전체/목록/캘린더 여부 열거형으로 구분해서 대응하기
class HomeViewController: BaseCustomViewController<HomeView> {

    let repository = TaskTableRepository()
    lazy var folderList = repository.fetchFolder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(repository.getFileURL())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 변경사항 있는 경우에만 reload하기
        mainView.collectionView.reloadData()
        mainView.tableView.reloadData()
    }
    
    override func configureView() {
        
        navigationItem.title = "전체"
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .plain, target: self, action: #selector(calendarButtonTapped))
        navigationItem.rightBarButtonItem = calendarButton
        
        mainView.delegate = self
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    @objc func calendarButtonTapped() {
        transition(style: .push, viewController: CalendarViewController.self)
    }

}

extension HomeViewController: HomeViewDelegate {
    
    func leftBarButtonTapped() {
        let vc = AddTaskViewController()
        vc.handler = {
            self.mainView.collectionView.reloadData()
            self.mainView.tableView.reloadData()
        }
        transition(style: .presentNavigation, viewController: vc)
    }
    
    func rightBarButtonTapped() {
        let vc = AddFolderViewController()
        vc.handler = {
            self.mainView.tableView.reloadData()
        }
        transition(style: .presentNavigation, viewController: vc)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "나의 목록"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
        
        let data = folderList[indexPath.row]
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = "\(data.task.count)"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskListViewController()
        vc.list = folderList[indexPath.row].task.sorted(byKeyPath: "regDate", ascending: true)
        vc.navTitle = folderList[indexPath.row].title
        transition(style: .push, viewController: vc)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailAction = UIContextualAction(style: .normal, title: "세부사항") { _, _, completion in
            let vc = AddFolderViewController()
            vc.data = self.folderList[indexPath.row]
            vc.handler = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            self.transition(style: .presentNavigation, viewController: vc)
            completion(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            for task in self.folderList[indexPath.row].task {
                self.removeImageFromDocument(filename: "\(task.id)")
            }
            self.repository.delete(self.folderList[indexPath.row])
            
            self.mainView.collectionView.reloadData()
            tableView.reloadData()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeCollection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell

        let homeCollection = HomeCollection.allCases[indexPath.item]
        cell.titleLabel.text = homeCollection.title
        
        let configImage = homeCollection.configImage
        cell.imageView.image = configImage.image
        cell.imageView.backgroundColor = configImage.backgroundColor
        
        cell.countLabel.text = "\(repository.fetch(homeCollection).count)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TaskListViewController()
        vc.collectionType = HomeCollection.allCases[indexPath.item]
        transition(style: .push, viewController: vc)
    }
    
}
