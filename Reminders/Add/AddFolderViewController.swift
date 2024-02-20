//
//  AddListViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/20/24.
//

import UIKit

class AddFolderViewController: BaseCustomViewController<AddFolderView> {
    
    var handler: (() -> Void)?
    var data: Folder?
    
    let repository = TaskTableRepository()
    
    override func configureView() {
        navigationItem.title = data == nil ? "새로운 목록" : "목록 정보"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: data == nil ? "추가" : "완료", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationController?.presentationController?.delegate = self
        
        if let data {
            mainView.titleTextField.text = data.title
        }
    }
    
    @objc func leftBarButtonTapped() {
        showAlertForDismiss()
    }
    
    @objc func rightBarButtonTapped() {
 
        view.endEditing(true)
        
        guard let title = mainView.titleTextField.text, !title.isEmpty else { view.makeToast("제목을 입력해주세요"); return }
        
        if let data {
            if data.title != title {
                repository.updateFolderTitle(data, title: title)
            }
        } else {
            let folder = Folder(title: title)
            repository.createFolder(folder)
        }
        
        handler?()
        dismiss(animated: true)
    }
    
}

extension AddFolderViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        showAlertForDismiss()
        return false
    }
 
}
