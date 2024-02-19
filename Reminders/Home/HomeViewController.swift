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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.collectionView.reloadData()
    }
    
    override func configureView() {
        
        navigationItem.title = "전체"
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .plain, target: self, action: #selector(calendarButtonTapped))
        navigationItem.rightBarButtonItem = calendarButton
        
        mainView.delegate = self
        
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
        }
        transition(style: .presentNavigation, viewController: vc)
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
        let vc = TaskListViewController()
        vc.collectionType = HomeCollection.allCases[indexPath.item]
        transition(style: .push, viewController: vc)
    }
    
}
