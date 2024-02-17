//
//  TaskTableRepository.swift
//  Reminders
//
//  Created by 이재희 on 2/16/24.
//

import Foundation
import RealmSwift

final class TaskTableRepository {
    
    private let realm = try! Realm()
    
    func getFileURL() -> URL? {
        realm.configuration.fileURL
    }
    
    func createItem(_ item: TaskTable) {

        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }

    }
    
    func fetch(_ type: HomeCollection, sortParam: (String, Bool) = SortType.deadline(ascending: true).sortParam) -> Results<TaskTable> {
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        switch type {
        case .today:
            return realm.objects(TaskTable.self).where {
                $0.deadline >= startDate && $0.deadline < endDate
            }.sorted(byKeyPath: sortParam.0, ascending: sortParam.1)
        case .scheduled:
            return realm.objects(TaskTable.self).where {
                $0.deadline >= endDate
            }.sorted(byKeyPath: sortParam.0, ascending: sortParam.1)
        case .all:
            return realm.objects(TaskTable.self).sorted(byKeyPath: sortParam.0, ascending: sortParam.1)
        case .flagged:
            return realm.objects(TaskTable.self).where { $0.isFlagged }.sorted(byKeyPath: sortParam.0, ascending: sortParam.1)
        case .completed:
            return realm.objects(TaskTable.self).where { $0.isDone }.sorted(byKeyPath: sortParam.0, ascending: !sortParam.1)
        }
    }
    
    //TODO: Update, Delete
}
