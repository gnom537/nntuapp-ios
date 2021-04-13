//
//  CoreDataStack.swift
//  nntu pre-alpha
//
//  Created by Дмитрий Юдин on 27.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    //MARK:- Search near lesson
    
    public func getTwoNearLessons(lessons: [Lesson]) -> (now: Lesson?, next: Lesson?) {
        
        var result: (now: Lesson?, next: Lesson?) = (nil, nil)
        
        if lessons.count == 0 {
            return result
        }
        else if lessons.count == 1 {
            result.now = lessons[0]
        }
        else {
            result.now = lessons[0]
            result.next = lessons[1]
        }
        
     return result
    }
    
    public func getNearLessons(lessons: [Lesson]) -> [Lesson]? {
        if lessons.count == 0 {
            return nil
        }
        
        var day = getCurrentDay()
        var week = getCurrentWeek()
        
        for _ in 1...15 {
            if day != 6 {
                day += 1
            } else {
                day = 0
                week += 1
            }
            
            let result = getSortedLessons(lessons: lessons, day: day, week: week)
            if result != nil {
//              Мы нашли что-то
                return result
            }
        }
//      Мы ничего не нашли
        return nil
    }
    

//MARK:- Today Lesson
    
    
//MARK: Get Today Two lessons
//  Return two lessons: now and next
    public func getTodayTwoLessons(lessons: [Lesson]) -> (now: Lesson?, next: Lesson?) {
        let index = getIndexLesson(lessons: lessons, date: Date())
        
        if index == nil {
//          Nothing
            return (nil, nil)
        }
        else if ((index! + 1) == lessons.count) {
//          Only one lessons has been finded
            return (lessons[index!], nil)
        }
        else {
//          Both lessons
            return (lessons[index!], lessons[index! + 1])
        }
    }
    
//MARK: Get Today Lessons
    public func getTodayLessons(lessons: [Lesson]? = nil) -> [Lesson]? {
        let input = lessons == nil ? fetchLessons() : lessons
        
        guard let sortedLessons = getSortedLessons(lessons: input!, day: getCurrentDay(), week: getCurrentWeek()) else {
            return nil
        }
        
        return sortedLessons
    }
    
//MARK: Sorting Lesson
    public func getSortedLessons(lessons: [Lesson], day: Int, week: Int) -> [Lesson]? {
        var result = [Lesson]()
        let currentWeek = week
        let currentDay = day
        
        let isEven = currentWeek % 2 == 0
        
        for lesson in lessons {
            if (lesson.weeks.contains(isEven ? -1 : -2) || lesson.weeks.contains(currentWeek)){
                if lesson.day == currentDay {
                    result.append(lesson)
                }
            }
        }
        result = result.sorted(by: {dateStringToInt(time: $0.stopTime) <= dateStringToInt(time: $1.stopTime)})
        
        return result.count == 0 ? nil : result
    }

    
    //  MARK: - Fetch LessonData
    public func fetchLessons() -> [Lesson] {
        var results = [LessonData]()
        var output = [Lesson]()
        
        do {
            results = try managedObjectContext.fetch(LessonData.fetchRequest())
        }
        catch let error as NSError? {
            print("Error clear CoreData \(error!), userInfo: \(error!.userInfo)")
        }
        
        if results.count != 0 {
            for object in results {
                var lesson = emptyLesson()
                
                var weeks = [Int]()
                var rooms = [String]()
                
                var tempWeekString = object.weeks ?? ""
                tempWeekString = tempWeekString.replacingOccurrences(of: " ", with: "")
                
                // convert string to array of weeks
                while (tempWeekString.contains(",")){
                    let index = tempWeekString.firstIndex(of: ",")!
                    weeks.append(Int(String(tempWeekString.prefix(upTo: index))) ?? 0)
                    tempWeekString = String(tempWeekString.suffix(from: index).dropFirst())
                }
                weeks.append(Int(tempWeekString) ?? 0)
                
                var tempRoomString = object.rooms ?? ""
                
                // convert string to array of rooms 
                while (tempRoomString.contains(",")){
                    let index = tempRoomString.firstIndex(of: ",")!
                    rooms.append(String(tempRoomString.prefix(upTo: index)))
                    tempRoomString = String(tempRoomString.suffix(from: index).dropFirst())
                }
                rooms.append(tempRoomString)
                
                if (rooms == [""]) {rooms = []}
                
                lesson.day = Int(object.day)
                lesson.name = object.name ?? ""
                lesson.notes = object.notes ?? ""
                lesson.rooms = rooms
                lesson.startTime = object.startTime ?? ""
                lesson.stopTime = object.stopTime ?? ""
                lesson.weeks = weeks
                lesson.teacher = object.teacher ?? ""
                lesson.type = object.type ?? ""
                
                output.append(lesson)
            }
        }
        
        return output
    }
    
    //  MARK: - Save Many Lessons
    public func saveManyLessons(objects: [Lesson]) {
        clearCoreData()
        
        for object in objects {
            save(object)
        }
    }
    
    //  MARK: - Clear CoreData
    public func clearCoreData() {
        var results = [NSManagedObject]()
        
        do {
            results = try managedObjectContext.fetch(LessonData.fetchRequest())
        }
        catch let error as NSError? {
            print("Error clear CoreData \(error!), userInfo: \(error!.userInfo)")
        }
        
        if results.count != 0  {
            for object in results {
                managedObjectContext.delete(object)
            }
        }
        
        saveContext()
    }
    
    //  MARK: - Save one lesson
    public func save(_ object: Lesson) {
        let newObject = LessonData(context: managedObjectContext)
        
        var weeks: String = ""
        var rooms: String = ""
        if (object.weeks.count > 0){
            for i in (0 ... object.weeks.count - 1){
                weeks += String(object.weeks[i]) + ","
            }
            weeks = String(weeks.dropLast(1))
        }
        if (object.rooms.count > 0){
            for i in (0 ... object.rooms.count - 1){
                rooms += object.rooms[i] + ","
            }
            rooms = String(rooms.dropLast(1))
        }
        
        newObject.day = Int16(object.day)
        newObject.startTime = object.startTime
        newObject.stopTime = object.stopTime
        newObject.weeks = weeks
        newObject.rooms = rooms
        newObject.notes = object.notes
        newObject.teacher = object.teacher
        newObject.name = object.name
        newObject.type = object.type
        
        self.saveContext()
    }
    
    
//  MARK: - Standart CoreData variables and funcs
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "nntu_pre_alpha")
        let url = URL.storeURL(appGroup: "group.nntu.share", CoreDataName: "nntu_pre_alpha")
        let storeDescriptions = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescriptions]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("error: \(error), userInfo: \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func saveContext() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            }
            catch let error as NSError? {
                print("Error saveContext: \(error!), userInfo: \(error!.userInfo)")
            }
        }
    }
    
}


// Extension for create container with appGroup
extension URL {
    static func storeURL(appGroup: String, CoreDataName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else { fatalError("Container URL could not be created.") }
        return fileContainer.appendingPathComponent("\(CoreDataName).sqlite")
    }
}
