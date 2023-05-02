//
//  TaskStorage.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 26.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import CoreData

final class TaskStorage {
    // утаскиваю из CoreDataStack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "nntu_pre_alpha")
        let url = URL.storeURL(appGroup: "group.nntu.share", CoreDataName: "nntu_pre_alpha")
        let storeDescriptions = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescriptions]
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("error: \(error), userInfo: \(error.userInfo)")
            }
        }
        return container
    }()
    var managedObjectContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    // MARK: - private I/O funcs
    private func fetch() throws -> [TaskData] {
        let cdObjects = try managedObjectContext.fetch(TaskData.fetchRequest())
        return cdObjects
    }

    private func clear() throws {
        let objects = try fetch()
        for object in objects {
            managedObjectContext.delete(object)
        }
        try managedObjectContext.save()
    }

    private func save(_ task: Task) throws {
        let object = TaskData(context: managedObjectContext)
        object.id = Int32(task.id)
        object.title = task.title
        object.desc = task.description
        object.subject = task.subject
        if let priority = task.priority?.rawValue {
            object.priority = Int16(priority)
        }
        object.deadline = task.deadline
        object.done = task.done
        try managedObjectContext.save()
    }

    private func save(_ tasks: [Task]) throws {
        try clear()
        for task in tasks {
            try save(task)
        }
    }

    // MARK: - public I/O
    var tasks: [Task] {
        get {
            do {
                let data = try fetch()
                let now = Date()
                var tasks = data.map {Task.init(from: $0)}
                tasks = tasks.filter { $0.deadline > now }
                return tasks
            } catch let error {
                print(error.localizedDescription)
                return []
            }
        }
        set {
            try? save(newValue)
        }
    }
}
