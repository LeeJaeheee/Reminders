//
//  AppDelegate.swift
//  Reminders
//
//  Created by 이재희 on 2/14/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(schemaVersion: 4) { migration,oldSchemaVersion in
            
            // Folder - iconColor 컬럼 추가
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Folder.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    new["iconColor"] = "blue"
                }
            }
            
            // TaskTable - detailTask: String? 컬럼 추가
            if oldSchemaVersion < 2 { }
            
            // TaskTable - detailTask: String? -> String
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: TaskTable.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    guard let priority = old["priority"] as? Int, let title = Priority(rawValue: priority)?.title else { return }
                    new["detailTask"] = old["detailTask"] ?? "\(old["title"]!)은 \(old["deadline"]!)까지 완료되어야 하는 우선순위 \(title)인 업무입니다."
                }
            }
            
            if oldSchemaVersion < 4 {
                migration.renameProperty(onType: TaskTable.className(), from: "detailTask", to: "taskDescription")
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

