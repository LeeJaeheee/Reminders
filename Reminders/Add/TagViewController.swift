//
//  TagViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit
import SnapKit

class TagViewController: BaseViewController {
    
    let textField = UITextField()
    
    var tagText: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tagText?(textField.text!)
    }
    
    override func configureHierarchy() {
        view.addSubview(textField)
    }
    
    override func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "태그를 입력해주세요."
    }

}
