//
//  HomeViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

protocol HomeViewDelegate {
    func leftBarButtonTapped()
    func rightBarButtonTapped()
}

class HomeViewController: BaseCustomViewController<HomeView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configureView() {
        mainView.delegate = self
        
    }

}

extension HomeViewController: HomeViewDelegate {
    
    func leftBarButtonTapped() {
        transition(style: .presentNavigation, viewController: AddTaskViewController.self)
    }
    
    func rightBarButtonTapped() {
        
    }
    
}
