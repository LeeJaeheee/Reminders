//
//  FileManager.swift
//  Reminders
//
//  Created by 이재희 on 2/19/24.
//

import UIKit

extension UIViewController {
    
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
    
}
