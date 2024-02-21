//
//  PriorityViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit
import SnapKit

final class PriorityViewController: BaseViewController {
    
    private let segmentedControl = UISegmentedControl()
    
    var priority: Int?
    var selectedIndex: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        selectedIndex?(segmentedControl.selectedSegmentIndex)
    }
    
    override func configureHierarchy() {
        view.addSubview(segmentedControl)
    }
    
    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        for item in Priority.allCases {
            segmentedControl.insertSegment(withTitle: item.title, at: item.rawValue, animated: true)
        }
        segmentedControl.selectedSegmentIndex = priority ?? 1
    }

}
