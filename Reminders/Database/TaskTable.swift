//
//  TaskTable.swift
//  Reminders
//
//  Created by 이재희 on 2/15/24.
//

import Foundation
import RealmSwift

class TaskTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var regDate: Date
    @Persisted var deadline: Date
    @Persisted var tag: String
    @Persisted var priority: Int
    @Persisted var isDone: Bool
    
    convenience init(title: String, memo: String? = nil, deadline: Date, tag: String, priority: Int) {
        self.init()
        self.title = title
        self.memo = memo
        self.regDate = Date()
        self.deadline = deadline
        self.tag = tag
        self.priority = priority
        self.isDone = false
    }
}
