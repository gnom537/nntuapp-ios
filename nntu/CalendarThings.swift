//
//  CalendarThings.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 22.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import EventKit
import UIKit

var store = EKEventStore()

func putTTinCalendar(tt: [Lesson]){
    store.requestAccess(to: .event, completion: { granted, error in
        var calendar = getCalendar()
        removeTTfromCalendar(id: calendar.calendarIdentifier)
        calendar = getCalendar()
        for lesson in tt {
            addLessonToCalendar(lesson, calendar: calendar)
        }
    })
}

func removeTTfromCalendar(id: String){
    do {
        if (store.calendar(withIdentifier: id) != nil){
            try store.removeCalendar(store.calendar(withIdentifier: id)!, commit: true)
        }
    } catch {
        print ("Can't delete calendar 😭")
    }
}

func getCalendar() -> EKCalendar {
    if let id = UserDefaults.standard.string(forKey: "calendarID"){
        if (store.calendar(withIdentifier: id) != nil){
            return store.calendar(withIdentifier: id) ?? EKCalendar()
        }
    }
    let calendar = EKCalendar(for: EKEntityType.event, eventStore: store)
    calendar.title = "НГТУ"
    calendar.cgColor = NNTUblue.cgColor
    calendar.source = store.defaultCalendarForNewEvents?.source
    do {
        try store.saveCalendar(calendar, commit: true)
        UserDefaults.standard.setValue(calendar.calendarIdentifier, forKey: "calendarID")
    } catch {
        print ("Something went wrong in getCalendar()")
    }
    return calendar
}

/*
 нужно каждую неделю перенести в календарь (пипяу)
 
 начало:
 0 неделя = 5 неделя 2021
 1 неделя = 6 неделя 2021
 то есть +5
 
 заканчиваем:
 конец мая:
 21 неделя 2021
 
 на самом деле рассуждать в комментах наверное даже клас
 */


func getStartTime(_ lesson: Lesson, _ isEveryWeek: Bool, _ week: Int) -> Date{
    var dateCompontens = DateComponents()
    dateCompontens.year = nowYear
    
    if isEveryWeek {
        dateCompontens.weekOfYear = startWeek + 1
    } else if lesson.weeks.contains(-2){
        dateCompontens.weekOfYear = startWeek + additionalWeek + 1
    } else if lesson.weeks.contains(-1){
        dateCompontens.weekOfYear = startWeek + 1 + 1 - additionalWeek
    } else {dateCompontens.weekOfYear = week + startWeek + 1 - additionalWeek}
    
    var tempDay = lesson.day + 1
    if (tempDay == 7) {tempDay = 1}
    else {tempDay += 1}
    
    dateCompontens.weekday = tempDay
    dateCompontens.timeZone = TimeZone(secondsFromGMT: 3600*3)
    let str = lesson.startTime
    
    
    let index = lesson.startTime.firstIndex(of: ":")
    let hours = Int(str.prefix(upTo: index ?? str.endIndex)) ?? 0
    let minutes = Int(str.suffix(from: str.index(after: index ?? str.startIndex))) ?? 0
    
    dateCompontens.hour = hours
    dateCompontens.minute = minutes
    
    
    var userCalendar = Calendar(identifier: .gregorian)
    userCalendar.locale = Locale(identifier: "ru_UA")
    return userCalendar.date(from: dateCompontens) ?? Date()
}

func getStopDate(_ startDate: Date, _ lesson: Lesson) -> Date {
    let str = lesson.stopTime
    
    let index = lesson.stopTime.firstIndex(of: ":")
    let hours = Int(str.prefix(upTo: index ?? str.endIndex)) ?? 0
    let minutes = Int(str.suffix(from: str.index(after: index ?? str.startIndex))) ?? 0
    
    var userCalendar = Calendar(identifier: .gregorian)
    userCalendar.locale = Locale(identifier: "ru_UA")
    
    let date = userCalendar.date(bySettingHour: hours, minute: minutes, second: 0, of: startDate) ?? Date()
    
    return date
}


func addLessonToCalendar(_ lesson: Lesson, calendar: EKCalendar){
    let isEveryWeek = lesson.weeks.contains(-1) && lesson.weeks.contains(-2)
    for week in lesson.weeks {
        let newEvent = EKEvent(eventStore: store)
        newEvent.title = lesson.name
        newEvent.location = stringFromRooms(rooms: lesson.rooms)
        newEvent.timeZone = TimeZone(secondsFromGMT: 3600*3)
        
        if (week == -1 || week == -2){
            let interval = isEveryWeek ? 1 : 2
            let rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: interval, end: EKRecurrenceEnd(end: getEndDate()))
            newEvent.recurrenceRules = [rule]
        }
        
        var tempString = ""
        tempString += lesson.type
        
        if (lesson.teacher != ""){
            if tempString != "" {tempString += ", "}
            tempString += lesson.teacher
        }
        
        if (lesson.notes != ""){
            if tempString != "" {tempString += ", "}
            tempString += lesson.notes
        }
        
        newEvent.notes = tempString
        
        let startDate = getStartTime(lesson, isEveryWeek, week)
        newEvent.startDate = startDate
        newEvent.endDate = getStopDate(startDate, lesson)
        newEvent.alarms = nil
        
//        if newEvent.startDate > newEvent.endDate {
//            let spareDate = newEvent.startDate
//            newEvent.startDate = newEvent.endDate
//            newEvent.endDate = spareDate
//        }
        
        newEvent.calendar = calendar
        
        do {
            try store.save(newEvent, span: EKSpan.thisEvent, commit: true)
        } catch {
            print ("Something went wrong in addLesson() while saving. \(error)")
        }
        if (isEveryWeek) {break}
    }
}


