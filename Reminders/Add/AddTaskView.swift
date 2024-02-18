//
//  AddTaskView.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

enum AddTask: Int, CaseIterable {
    case memo
    case deadline
    case tag
    case priority
    case image
    
    var title: String {
        switch self {
        case .memo:
            "제목"
        case .deadline:
            "마감일"
        case .tag:
            "태그"
        case .priority:
            "우선 순위"
        case .image:
            "이미지 추가"
        }
    }
    
    var notiName: String {
        switch self {
        case .memo:
            ""
        case .deadline:
            "DeadlineReceived"
        case .tag:
            "TagReceived"
        case .priority:
            "PriorityReceived"
        case .image:
            ""
        }
    }
}

class AddTaskView: BaseView {
    
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

