//
//  BaseViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

class BaseCustomViewController<T: BaseView>: BaseViewController {
    
    let mainView: T = T()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
