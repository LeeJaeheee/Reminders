//
//  BaseViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit

enum TransitionStyle {
    case present
    case presentNavigation
    case presentFullNavigation
    case push
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    func transition<U: UIViewController>(style: TransitionStyle, viewController: U.Type) {
        let vc = U()
        
        transition(style: style, viewController: vc)
    }
    
    func transition<U: UIViewController>(style: TransitionStyle, viewController: U) {

        switch style {
        case .present:
            present(viewController, animated: true)
        case .presentNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            present(nav, animated: true)
        case .presentFullNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, okTitle: String = "확인", okStyle: UIAlertAction.Style = .default, showCancelButton: Bool = false, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: okTitle, style: okStyle) { _ in
            handler?()
        }
        alert.addAction(okAction)
        if showCancelButton {
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        present(alert, animated: true)
    }
    
    func showAlertForDismiss() {
        showAlert(style: .actionSheet, okTitle: "변경사항 폐기", okStyle: .destructive, showCancelButton: true) {
            self.dismiss(animated: true)
        }
    }

}
