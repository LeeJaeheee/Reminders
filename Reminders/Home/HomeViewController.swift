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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureView() {
        
        navigationItem.title = "전체"
        
        let items = UIMenu(title: "정렬 기준", options: .displayInline, children: [
            UIAction(title: "마감일", handler: { _ in
                
            }),
            UIAction(title: "제목", handler: { _ in
                
            }),
            UIAction(title: "우선순위", handler: { _ in
                
            })
        ])
        
        let sortType = UIMenu(title: "정렬 순서",options: .displayInline, children: [
            UIAction(title: "오름차순", handler: { _ in
                
            }),
            UIAction(title: "내림차순", handler: { _ in
                
            })
        ])
        
        let button = UIButton()
        button.menu = UIMenu(children: [items, sortType])
        button.showsMenuAsPrimaryAction = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        mainView.delegate = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }

}

extension HomeViewController: HomeViewDelegate {
    
    func leftBarButtonTapped() {
        transition(style: .presentNavigation, viewController: AddTaskViewController.self)
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
        
        cell.countLabel.text = "\(homeCollection.database.count)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == HomeCollection.all.rawValue {
            
        }
    }
    
}
