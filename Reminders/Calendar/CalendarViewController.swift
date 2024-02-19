//
//  CalendarViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/19/24.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseCustomViewController<CalendarView> {
    
    var childViewController: TaskListViewController?
    let repository = TaskTableRepository()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        addChild(mainView.childVC)
        mainView.childVC.didMove(toParent: self)
        
        childViewController = mainView.childVC
        
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        mainView.calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let events = repository.fetchSpecificDate(date)
        return events.count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        childViewController?.list = repository.fetchSpecificDate(date)
        childViewController?.tableView.reloadData()
    }
    
}
