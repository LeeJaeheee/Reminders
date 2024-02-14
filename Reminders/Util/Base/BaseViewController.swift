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

class BaseViewController<T: BaseView>: UIViewController {
    
    var mainView: T!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = T()
        configureView()
    }
    
    func configureView() { }
    
    func transition<U: UIViewController>(style: TransitionStyle, viewController: U.Type) {
        let vc = U()
        
        switch style {
        case .present:
            present(vc, animated: true)
        case .presentNavigation:
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        case .presentFullNavigation:
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, okTitle: String = "확인", showCancelButton: Bool = false, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            handler?()
        }
        alert.addAction(okAction)
        if showCancelButton {
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        present(alert, animated: true)
    }
    
}
