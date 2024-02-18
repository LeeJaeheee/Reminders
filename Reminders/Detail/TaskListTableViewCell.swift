//
//  TaskListTableViewCell.swift
//  Reminders
//
//  Created by 이재희 on 2/19/24.
//

import UIKit
import SnapKit

class TaskListTableViewCell: BaseTableViewCell {
    
    let priorityLabel = UILabel()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let deadlineLabel = UILabel()
    let tagLabel = UILabel()
    
    override func configureHierarchy() {
        [priorityLabel, titleLabel, memoLabel, deadlineLabel, tagLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        priorityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(28)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(priorityLabel.snp.trailing).offset(8)
            make.trailing.equalTo((accessoryView?.snp.leading) ?? contentView.snp.trailing).offset(-12)
            make.height.equalTo(24)
        }
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(titleLabel)
        }
        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        tagLabel.snp.makeConstraints { make in
            make.leading.equalTo(deadlineLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(titleLabel)
            make.centerY.equalTo(deadlineLabel)
        }

    }
    
    override func configureView() {
        priorityLabel.font = .systemFont(ofSize: 24)
        
        titleLabel.font = .systemFont(ofSize: 14)
        
        memoLabel.font = .systemFont(ofSize: 12)
        memoLabel.textColor = .systemGray
        memoLabel.numberOfLines = 2
        
        deadlineLabel.font = .systemFont(ofSize: 12)
        deadlineLabel.textColor = .systemGray
        
        tagLabel.font = .systemFont(ofSize: 12)
        tagLabel.textColor = .systemCyan
    }
    
    func configureCell(_ data: TaskTable) {
        accessoryType = data.isDone ? .checkmark : .none
        tintColor = .systemYellow
        
        priorityLabel.text = data.priority == 0 ? "😸" : data.priority == 1 ? "😼" : "🙀"
        
        titleLabel.text = data.title
        
        memoLabel.text = data.memo
        
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MM/dd"
            self.deadlineLabel.text = dateFormatter.string(from: data.deadline)
            
            self.tagLabel.text = "#" + data.tag
        }
    }
    
}
