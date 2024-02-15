//
//  BaseViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

enum TransitionStyle {
    case present
    case presentNavigation
    case presentFullNavigation
    case push
}

class BaseCustomViewController<T: BaseView>: BaseViewController {
    
    var mainView: T = T()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
