//
//  UIView+Extension.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import UIKit

extension UIView {
    
    func setCornerRadius(_ cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
}
