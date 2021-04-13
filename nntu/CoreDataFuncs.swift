//
//  CoreDataNDB.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 22.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//MARK: - save()
func save(object: Lesson){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "LessonData", in: managedContext)!
    //New Core Data Lesson
    let NCDLesson = NSManagedObject(entity: entity, insertInto: managedContext)
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
    
    NCDLesson.setValue(object.startTime, forKey: "startTime")
    NCDLesson.setValue(object.stopTime, forKey: "stopTime")
    NCDLesson.setValue(object.day, forKey: "day")
    NCDLesson.setValue(weeks, forKey: "weeks")
    NCDLesson.setValue(rooms, forKey: "rooms")
    NCDLesson.setValue(object.name, forKey: "name")
    NCDLesson.setValue(object.type, forKey: "type")
    NCDLesson.setValue(object.teacher, forKey: "teacher")
    NCDLesson.setValue(object.notes, forKey: "notes")
    
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Не получилось сохранить \(error), \(error.userInfo)")
    }
}


func clearCD(){
    let entity = "LessonData"
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false
    do {
        let results = try managedContext.fetch(fetchRequest)
        for object in results {
            guard let objectData = object as? NSManagedObject else {continue}
            managedContext.delete(objectData)
        }
        try managedContext.save()
    } catch let error {
        print("Detele all data in \(entity) error :", error)
    }
}


//MARK: - saveManyLessons
func saveManyLessons (lessons : [Lesson]){
    clearCD()
    if (lessons.count != 0){
        for i in (0 ... lessons.count - 1){
            save(object: lessons[i])
        }
    }
}


//MARK: - CoreDataLoadLessons()
func CDLoadLessons() -> [Lesson]{
    var output = [Lesson]()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return output}
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LessonData")
    var CDLessons : [NSManagedObject] = []
    
    do {
        CDLessons = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Не удалось загрузить из CoreData \(error), \(error.userInfo)")
    }
    
    if (CDLessons.count > 0){
        for i in (0 ... CDLessons.count - 1){
            var tempLesson = emptyLesson()
            var tempWeeks = [Int]()
            var tempWeekString = CDLessons[i].value(forKey: "weeks") as? String ?? ""
            tempWeekString = tempWeekString.replacingOccurrences(of: " ", with: "")
            while (tempWeekString.contains(",")){
                let index = tempWeekString.firstIndex(of: ",")!
                tempWeeks.append(Int(String(tempWeekString.prefix(upTo: index))) ?? 0)
                tempWeekString = String(tempWeekString.suffix(from: index).dropFirst())
            }
            tempWeeks.append(Int(tempWeekString) ?? 0)
            
            var tempRooms = [String]()
            var tempRoomString = CDLessons[i].value(forKey: "rooms") as? String ?? ""
            while (tempRoomString.contains(",")){
                let index = tempRoomString.firstIndex(of: ",")!
                tempRooms.append(String(tempRoomString.prefix(upTo: index)))
                tempRoomString = String(tempRoomString.suffix(from: index).dropFirst())
            }
            tempRooms.append(tempRoomString)
            
            
            
            
            tempLesson.startTime = CDLessons[i].value(forKey: "startTime") as? String ?? ""
            tempLesson.stopTime = CDLessons[i].value(forKey: "stopTime") as? String ?? ""
            tempLesson.day = CDLessons[i].value(forKey: "day") as? Int ?? 0
            tempLesson.weeks = tempWeeks
            tempLesson.rooms = tempRooms
            tempLesson.name = CDLessons[i].value(forKey: "name") as? String ?? ""
            tempLesson.type = CDLessons[i].value(forKey: "type") as? String ?? ""
            tempLesson.teacher = CDLessons[i].value(forKey: "teacher") as? String ?? ""
            tempLesson.notes = CDLessons[i].value(forKey: "notes") as? String ?? ""
            output.append(tempLesson)
        }
    }
    
    return output
}
