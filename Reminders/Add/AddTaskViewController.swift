//
//  AddTaskViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

class AddTaskViewController: BaseViewController<AddTaskView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configureView() {
        navigationItem.title = "새로운 할 일"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    @objc func leftBarButtonTapped() {
        
    }
    
    @objc func rightBarButtonTapped() {
        
    }

}
