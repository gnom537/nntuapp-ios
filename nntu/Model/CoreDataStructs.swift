//
//  CoreDataStructs.swift
//  nntu pre-alpha
//
//  Created by Дмитрий Юдин on 27.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation

//MARK: - New TimeTable structure
struct Lesson {
    var id = UUID()
    var startTime : String
    var stopTime : String
    var day : Int
    var weeks : [Int]
    var rooms : [String]
    var name : String
    var type : String
    var teacher : String
    var notes : String
}


//MARK: - Mark structure
struct MarkLesson {
    var id = UUID()
    var name: String
    var type: String
    var result: String
    var firstWeek: String
    var secondWeek: String
    var missedFirstWeek: String
    var missedSecondWeek: String
}

var editingTT = [Lesson]()

func emptyLesson() -> Lesson {
    return Lesson(startTime: "", stopTime: "", day: 0, weeks: [], rooms: [], name: "", type: "", teacher: "", notes: "")
}
