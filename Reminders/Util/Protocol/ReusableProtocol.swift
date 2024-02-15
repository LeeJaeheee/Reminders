//
//  ReusableProtocol.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit

protocol ReusableProtocol {
    
    static var identifier: String { get }
    
}

extension UIViewController: ReusableProtocol {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UIView: ReusableProtocol {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

