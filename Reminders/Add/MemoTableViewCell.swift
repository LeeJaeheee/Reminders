//
//  MemoTableViewCell.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit
import SnapKit

// TODO: 텍스트뷰 내용 길이에 따라 동적으로 늘리기
class MemoTableViewCell: UITableViewCell, ConfigureProtocol {

    let titleTextField = UITextField()
    let line = UIView()
    let memoTextView = UITextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(titleTextField)
        contentView.addSubview(line)
        contentView.addSubview(memoTextView)
    }
    
    func configureLayout() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.height.equalTo(40)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(70)
        }
    }
    
    func configureView() {
        titleTextField.placeholder = "제목"
        titleTextField.font = .systemFont(ofSize: 15)
        line.backgroundColor = .systemGray6
        
        titleTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MemoTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        memoTextView.becomeFirstResponder()
        return true
    }
    
}
