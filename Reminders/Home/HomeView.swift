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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var delegate: HomeViewDelegate?
    
    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(toolbar)
    }
    
    override func configureLayout() {
        
        toolbar.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(toolbar.snp.top)
        }
        
    }
    
    override func configureView() {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.contentInsets = .zero
        let button = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            self.leftBarButtonTapped()
        }))
        button.setTitle("새로운 미리 알림", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        let leftBarButton = UIBarButtonItem(customView: button)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: "목록 추가", primaryAction: UIAction(handler: { _ in
            self.rightBarButtonTapped()
        }))
 
        toolbar.items = [leftBarButton, spacer, rightBarButton]
        
        collectionView.backgroundColor = .clear
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
    
    static func collectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing: CGFloat = 16
        let width = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: width * 0.5)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    @objc func leftBarButtonTapped() {
        delegate?.leftBarButtonTapped()
    }
    
    @objc func rightBarButtonTapped() {
        delegate?.rightBarButtonTapped()
    }
}
