//
//  HomeView.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit
import SnapKit

class HomeView: BaseView {
    // iPhone 15 Pro : width는 45, height은 11
    // iPhone 15 Pro Max : width는 53, height 16 이상이어야 경고가 안뜸 왜지..?
    let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 53, height: 16))
    
    var delegate: HomeViewDelegate?
    
    override func configureHierarchy() {
        addSubview(toolbar)
    }
    
    override func configureLayout() {
        toolbar.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        let leftBarButton = UIBarButtonItem(title: "새로운 미리 알림", image: UIImage(systemName: "plus.circle.fill"), target: self, action: #selector(leftBarButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: "목록 추가")
        toolbar.items = [leftBarButton, spacer, rightBarButton]
    }
    
    @objc func leftBarButtonTapped() {
        delegate?.leftBarButtonTapped()
    }
}
