//
//  HomeCollectionViewCell.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell, ConfigureProtocol {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setCornerRadius(12)
        imageView.setCornerRadius(12)
    }

    func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(14)
            make.size.equalTo(36)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.leading).offset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(imageView.snp.trailing).offset(16)
            make.top.trailing.equalToSuperview().inset(14)
            make.height.equalTo(imageView.snp.height)
        }
    }
    
    func configureView() {
        backgroundColor = .systemBackground
        
        imageView.tintColor = .white
        imageView.contentMode = .center
        
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 13.5)
        
        countLabel.font = .boldSystemFont(ofSize: 26)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
