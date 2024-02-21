//
//  AddListView.swift
//  Reminders
//
//  Created by 이재희 on 2/20/24.
//

import UIKit
import SnapKit

final class AddFolderView: BaseView {
    
    let titleView = UIView()
    let titleTextField = UITextField()
    
    override func configureHierarchy() {
        addSubview(titleView)
        titleView.addSubview(titleTextField)
    }
    
    override func configureLayout() {
        titleView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(160)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        titleView.backgroundColor = .systemBackground
        titleView.setCornerRadius(12)
        
        titleTextField.backgroundColor = .systemGray3
        titleTextField.placeholder = "목록 이름"
        titleTextField.borderStyle = .roundedRect
        titleTextField.textAlignment = .center
    }
}
