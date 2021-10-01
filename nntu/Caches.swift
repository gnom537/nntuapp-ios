//
//  Caches.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 28.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire


var freeLesson: Lesson? = nil
var editingIndex: Int? = nil

var TTeditorVC: DBEditorViewController? = nil
var AUSwitch: UISwitch?

var coreDiss : [NSManagedObject] = []

var dateForTT : Date? = nil
var freeDBTTController: DBTTController? = nil

func successFeedback(){
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

func errorFeedback(){
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
}

struct JSONTtable: Codable {
    var startTimes : [String]
    var stopTimes: [String]
    var days: [String]
    var weeks: [String]
    var rooms: [String]
    var names: [String]
    var types: [String]
    var teachers: [String]
    var notes: [String]
}

func stringFromWeeks(weeks: [Int]) -> String{
    var tempWeeks = ""
    if (weeks.count == 0) {return ""}
    for j in (0 ... weeks.count - 1){
        tempWeeks += String(weeks[j]) + ","
    }
    return String(tempWeeks.dropLast(1))
}

func stringFromRooms(rooms: [String]) -> String{
    var tempRooms = ""
    if (rooms.count == 0 || rooms == [""]) {return ""}
    for j in (0 ... rooms.count - 1){
        tempRooms += rooms[j] + ","
    }
    return String(tempRooms.dropLast(1))
}

func weeksFromString(weeks: String) -> [Int]{
    var input = weeks
    input = input.replacingOccurrences(of: " ", with: "")
    var output = [Int]()
    while (input.contains(",")){
        let index = input.firstIndex(of: ",")!
        output.append(Int(String(input.prefix(upTo: index))) ?? 0)
        input = String(input.suffix(from: index).dropFirst())
    }
    output.append(Int(input) ?? 0)
    return output
}

func roomsFromString(rooms: String) -> [String]{
    var input = rooms
    var output = [String]()
    while (input.contains(",")){
        let index = input.firstIndex(of: ",")!
        output.append(String(input.prefix(upTo: index)))
        input = String(input.suffix(from: index).dropFirst())
    }
    output.append(input)
    if (output == [""]) {output = []}
    return output
}

//    MARK: timeFromString()
func timeFromString(string: String) -> Int{
    return Int(string.replacingOccurrences(of: ":", with: "")) ?? 0
}

func sortByTime(_ lessons: [Lesson]) -> [Lesson]{
    return lessons.sorted(by: {timeFromString(string: $0.startTime) < timeFromString(string: $1.startTime)})
}

func uploadTT(_ tt: [Lesson], groupName: String, comletition: @escaping (Bool) -> (Void)){
    var startTimes = [String]()
    var stopTimes = [String]()
    var days = [Int]()
    var weeks = [String]()
    var rooms = [String]()
    var names = [String]()
    var types = [String]()
    var teachers = [String]()
    var notes = [String]()
    if (tt.count > 0){
        for i in (0 ... tt.count - 1){
            startTimes.append(tt[i].startTime)
            stopTimes.append(tt[i].stopTime)
            days.append(tt[i].day)
            weeks.append(stringFromWeeks(weeks: tt[i].weeks))
            rooms.append(stringFromRooms(rooms: tt[i].rooms))
            names.append(tt[i].name)
            types.append(tt[i].type)
            teachers.append(tt[i].teacher)
            notes.append(tt[i].notes)
        }
    }
    let params: [String : Any] = [
        "key": postKey,
        "groupName" : groupName.replacingOccurrences(of: "DROP", with: "").replacingOccurrences(of: "'", with: ""),
        "startTimes" : startTimes,
        "stopTimes" : stopTimes,
        "days" : days,
        "weeks" : weeks,
        "rooms" : rooms,
        "names" : names,
        "types" : types,
        "teachers" : teachers,
        "notes" : notes
    ]
    
    AF.request("http:/194.58.97.17:3000/", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
        switch response.result{
        case .success(let value):
            comletition(true)
//            print(value)
        case .failure(let err):
            comletition(false)
            print(err)
        }
    }
}

func downloadTT(_ groupName: String, callback: @escaping ([Lesson]) -> (Void)){
    var output = [Lesson]()
    let params: [String : Any] = [
        "key": receiveKey,
        "groupName": groupName
    ]
    AF.request("http:/194.58.97.17:3000/", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
        switch response.result{
        case .success(let value):
//            print(value)
            if let json = value as? [String : Any]{
                let startTimes = json["startTimes"] as? [String] ?? [String]()
                let stopTimes = json["stopTimes"] as? [String] ?? [String]()
                let days = json["days"] as? [Int] ?? [Int]()
                let weeks = json["weeks"] as? [String] ?? [String]()
                let rooms = json["rooms"] as? [String] ?? [String]()
                let names = json["names"] as? [String] ?? [String]()
                let types = json["types"] as? [String] ?? [String]()
                let teachers = json["teachers"] as? [String] ?? [String]()
                let notes = json["notes"] as? [String] ?? [String]()
                
                if (startTimes.count > 0){
                    for i in (0 ... startTimes.count - 1){
                        var tempLesson = emptyLesson()
                        tempLesson.startTime = startTimes[i]
                        tempLesson.stopTime = stopTimes[i]
                        tempLesson.day = days[i]
                        tempLesson.weeks = weeksFromString(weeks: weeks[i])
                        tempLesson.rooms = roomsFromString(rooms: rooms[i])
                        tempLesson.name = names[i]
                        tempLesson.type = types[i]
                        tempLesson.teacher = teachers[i]
                        tempLesson.notes = notes[i]
                        
                        output.append(tempLesson)
                    }
                }
                
                callback(output)
            }
//            print(value)
        case .failure(let err):
            callback(output)
            print(err)
        }
    }
}





//MARK: - save()
func save (input: DisTime) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "CoreDisTime", in: managedContext)!
    let disTime = NSManagedObject(entity: entity, insertInto: managedContext)
    disTime.setValue(input.Aud ?? "null", forKey: "room")
    disTime.setValue(input.Name ?? "null", forKey: "name")
    disTime.setValue(input.StartTime ?? "null", forKey: "startTime")
    disTime.setValue(input.StopTime ?? "null", forKey: "stopTime")
    do {
        try managedContext.save()
        coreDiss.append(disTime)
    } catch let error as NSError {
        print ("Не получилось сохранить \(error), \(error.userInfo)")
    }
}

//MARK: - fetch()
func fetch (){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreDisTime")
    
    do {
        coreDiss = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print ("Не получилось достать данные /(error), \(error.userInfo)")
    }
}

//MARK: - saveTimeTable()
func saveTimeTable (input: TimeTable) {
    for i in 0...1 {
        for j in 0...5 {
            for k in 0...5 {
                save(input: input.TimeTable[i]?.Days[j]?.Paras[k] ?? DisTime())
            }
        }
    }
}

//MARK: - fetchParas()
func fetchParas () -> [DisTime] {
    fetch()
    var output : [DisTime] = []
    if coreDiss.count == 0 {return output}
    for i in 0...coreDiss.count - 1 {
        let coreDis = coreDiss[i]
        var lesson = DisTime()
        lesson.Name = coreDis.value(forKey: "name") as? String
        lesson.StartTime = coreDis.value(forKey: "startTime") as? String
        lesson.StopTime = coreDis.value(forKey: "stopTime") as? String
        lesson.Aud = coreDis.value(forKey: "room") as? String
        output.append(lesson)
    }
    return output
}

//MARK: - fetchTimeTable()
func fetchTimeTable () -> TimeTable? {
    var output = TimeTable()
    let allParas = fetchParas()
    var index = 0
    if allParas.count == 0 {return output}
    for i in 0...1 {
        for j in 0...5 {
            for k in 0...5 {
                index = k + j*6 + i*36
                output.TimeTable[i]?.Days[j]?.Paras[k] = allParas[index]
            }
        }
    }
    print(output)
    return output
}

//MARK: deleteAllData()
func deleteAllData(_ entity:String) {
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
    } catch let error {
        print("Detele all data in \(entity) error :", error)
    }
}


//MARK: - stringFromTimeTable
func stringFromTimeTable (input: TimeTable) -> String {
    var output = String()
    for i in 0...1{
        for j in 0...5 {
            for k in 0...5 {
                let lesson = input.TimeTable[i]?.Days[j]?.Paras[k]
                output.append(lesson?.StartTime ?? "null")
                output.append("&&&")
                output.append(lesson?.StopTime ?? "null")
                output.append("&&&")
                output.append(lesson?.Name ?? "null")
                output.append("&&&")
                output.append(lesson?.Aud ?? "null")
                output.append("&&&")
            }
        }
    }
    return output
}


//MARK: - POSTtoServe()
func POSTtoServer (input: String){
    
    var groupName = UserDefaults.standard.string(forKey: "Group") ?? "null"
    
    if groupName != "null" {
        groupName.append(".txt")
    }
    
    let parameters: [String : String] = [
        "data" : input,
        "name" : groupName
    ]
    
    AF.request("http://194.58.97.17/post.php", method: .post, parameters: parameters).validate().responseString{
        response in
        let generator = UINotificationFeedbackGenerator()
        switch response.result {
        case .success(_):
            print(response.value ?? "ничего нет")
            generator.notificationOccurred(.success)
        case .failure(let error):
            generator.notificationOccurred(.error)
            print(error)
        }
    }
}


//MARK: - GETfromServer
func GETfromServer (comletition: @escaping (String) -> (Void)){
    
    var output = String()
    
    var groupName = UserDefaults.standard.string(forKey: "Group") ?? "null"
    
    if groupName != "null" {
        groupName.append(".txt")
    }
    
    let parameters: [String : String] = [
        "name" : groupName
    ]
    
    AF.request("http://194.58.97.17/get.php", method: .post, parameters: parameters).validate().responseString{ response in
        switch response.result {
        case .success(_):
            output = response.value ?? "null"
        case .failure(_):
            print ("Не получилось достать данные расписания из интернета")
        }; comletition(output)
    }
}








//MARK: - scrapeTimeTable
func scrapeTimeTable (input: String) -> [DisTime] {
    var lessons = [DisTime]()
    var webcontent = input
    
    var StartTime, StopTime, Name, Room : String?
    
    let theWord = """
&amp;&amp;&amp;
"""
    
    while (webcontent.contains(theWord) == true){
        
        //StartTime
        if let firstWordRange = webcontent.range(of: theWord) {
            let stopIndex = firstWordRange.lowerBound
            let newStartIndex = firstWordRange.upperBound
            StartTime = String(webcontent.prefix(upTo: stopIndex))
            webcontent = String(webcontent.suffix(from: newStartIndex))
        }
        
        //StopTime
        if let secondWordRange = webcontent.range(of: theWord) {
            let stopIndex = secondWordRange.lowerBound
            let newStartIndex = secondWordRange.upperBound
            StopTime = String(webcontent.prefix(upTo: stopIndex))
            webcontent = String(webcontent.suffix(from: newStartIndex))
        }
        
        //Name
        if let thirdWordRange = webcontent.range(of: theWord){
            let stopIndex = thirdWordRange.lowerBound
            let newStartIndex = thirdWordRange.upperBound
            Name = String(webcontent.prefix(upTo: stopIndex))
            webcontent = String(webcontent.suffix(from: newStartIndex))
        }
        
        //Room
        if let fourthWordRange = webcontent.range(of: theWord){
            let stopIndex = fourthWordRange.lowerBound
            let newStartIndex = fourthWordRange.upperBound
            Room = String(webcontent.prefix(upTo: stopIndex))
            webcontent = String(webcontent.suffix(from: newStartIndex))
        }
        
        if StartTime == "null" {
            StartTime = nil
        }
        if StopTime == "null" {
            StopTime = nil
        }
        if Name == "null" {
            Name = nil
        }
        if Room == "null" {
            Room = nil
        }
        
        lessons.append(DisTime(Name: Name, Aud: Room, StartTime: StartTime, StopTime: StopTime, Number: nil))
    }
    
    
    return lessons
}


//MARK: - disTimeToTimeTable
func disTimeToTimeTable (lessons: [DisTime]) -> TimeTable {
    var output = TimeTable()
    var index = 0
    for i in 0...1 {
        for j in 0...5 {
            for k in 0...5 {
                index = k + j*6 + i*36
                output.TimeTable[i]?.Days[j]?.Paras[k] = lessons[index]
            }
        }
    }
    return output
}


