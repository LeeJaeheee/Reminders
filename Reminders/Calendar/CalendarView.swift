//
//  CalendarView.swift
//  Reminders
//
//  Created by 이재희 on 2/19/24.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarView: BaseView {
    
    let calendar = FSCalendar()
    let childVC = TaskListViewController()
    
    override func configureHierarchy() {
        addSubview(calendar)
        addSubview(childVC.view)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(400)
        }
        childVC.view.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaInsets)
        }
    }
    
    override func configureView() {
        calendar.scope = .week
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        print(#function)
        if swipe.direction == .up {
            calendar.scope = .week
        }
        else if swipe.direction == .down {
            calendar.scope = .month
        }
    }
}
