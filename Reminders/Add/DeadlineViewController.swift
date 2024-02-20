//
//  DeadlineViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit
import SnapKit

class DeadlineViewController: BaseViewController {
    
    let datePicker = UIDatePicker()
    
    var deadline: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name(AddTask.deadline.notiName), object: nil, userInfo: [AddTask.deadline: datePicker.date])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name(AddTask.deadline.notiName), object: nil, userInfo: [AddTask.deadline: datePicker.date])
    }

    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setDate(deadline ?? Date(), animated: false)
    }

}
