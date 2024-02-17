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

class HomeViewController: BaseCustomViewController<HomeView> {

    let repository = TaskTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureView() {
        
        navigationItem.title = "전체"
        
        mainView.delegate = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }

}

extension HomeViewController: HomeViewDelegate {
    
    func leftBarButtonTapped() {
        let vc = AddTaskViewController()
        vc.handler = {
            if $0 {
                self.mainView.collectionView.reloadData()
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
        //transition(style: .presentNavigation, viewController: AddTaskViewController.self)
    }
    
    func rightBarButtonTapped() {
        
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
        if indexPath.item == HomeCollection.all.rawValue {
            navigationController?.pushViewController(TaskListViewController(), animated: true)
        }
    }
    
}
