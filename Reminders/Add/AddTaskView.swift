//
//  AddTaskView.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

final class AddTaskView: BaseView {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 0
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.identifier)
    }
    
}

