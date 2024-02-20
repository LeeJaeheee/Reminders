//
//  FileManager.swift
//  Reminders
//
//  Created by 이재희 on 2/19/24.
//

import UIKit

// 뷰컨의 extension으로 선언하지 않고 클래스나 열거형으로 만들면..? UIView나 다른 클래스에서 호출하고 싶어서..? 예를들어, FileManager_delete에서..
extension UIViewController {
    // 이 경로가 변경될 여지가 있는지..?
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func saveImageToDocument(_ image: UIImage, filename: String) {
        guard let fileURL = UIViewController.documentDirectory?.appendingPathComponent("\(filename).jpg") else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        guard let fileURL = UIViewController.documentDirectory?.appendingPathComponent("\(filename).jpg") else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return nil
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let fileURL = UIViewController.documentDirectory?.appendingPathComponent("\(filename).jpg") else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("file remove error", error)
            }
        } else {
            print("file not exist, remove error")
        }
    }
    
}
