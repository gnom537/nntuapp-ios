//
//  DateFunctions.swift
//  nntu pre-alpha
//
//  Created by Дмитрий Юдин on 06.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Date functions

func getCurrentWeek(date: Date = Date()) -> Int {
    var userCalendar = Calendar.current
    userCalendar.locale = Locale(identifier: "ru_UA")
    let weekOfYear = userCalendar.component(.weekOfYear, from: date) - 5
    return weekOfYear
}

func getCurrentDay(date: Date = Date()) -> Int {
    var userCalendar = Calendar.current
    userCalendar.locale = Locale(identifier: "ru_UA")
    var day = userCalendar.component(.weekday, from: date)
    if (day == 1){
        day = 7
    } else {day -= 1}
    return day - 1
}

/// return -1 if lessons end or zero lesson today
func getIndexLesson(lessons: [Lesson], date: Date) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    
    let time = dateStringToInt(time: dateFormatter.string(from: date))
    
    if lessons.count != 0 {
        for i in 0...lessons.count - 1 {
            if (dateStringToInt(time: lessons[i].stopTime) > time) {
                print("index: \(i)")
                return i
            }
        }
        
    }
    
    return nil
}

// RETURN: INT MINUTES!!
func calculateDates(timeStart: String, timeEnd: String) -> Int? {
    let start = dateStringToInt(time: timeStart)
    var end = dateStringToInt(time: timeEnd)
    
    let minutesStart = start % 100
    var minutesEnd = end % 100
    
    if start < end {
        if minutesEnd < minutesStart {
            if end < 100 {
                //              00:xx
                end += 2300
            }
            else {
                end -= 100
            }
            minutesEnd += 60
        }
        let hours = end / 100 - start / 100
        let minutes = minutesEnd - minutesStart
        
        return hours * 60 + minutes
    }
    
    return nil
}

// convert dateString to int
func dateStringToInt(time: String) -> Int {
    let output = time.replacingOccurrences(of: ":", with: "")
    
    return Int(output) ?? 0
}

// MARK:- Time Table (old widget)

// Get string for label in time table widget 
public func getTodayLabel() -> String {
    var userCalendar = Calendar.current
    userCalendar.locale = Locale(identifier: "ru_UA")
    
    print(userCalendar.component(.weekday, from: Date()))
    
    return "Сегодня \(userCalendar.component(.day, from: Date())) \(Months[userCalendar.component(.month, from: Date())-1]), \(ShortDaysOfWeek[userCalendar.component(.weekday, from: Date()) - 1])"
}


//MARK: Time arrays 
let DaysOfWeek : [String] = [NSLocalizedString("Понедельник", comment: ""), NSLocalizedString("Вторник", comment: ""), NSLocalizedString("Среда", comment: ""), NSLocalizedString("Четверг", comment: ""), NSLocalizedString("Пятница", comment: ""), NSLocalizedString("Суббота", comment: ""), NSLocalizedString("Воскресенье", comment: "")]

let ShortDaysOfWeek : [String] = ["вс", "пн", "вт", "ср", "чт", "пт", "сб"]

let normalShortDayOfWeek = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]

let Months : [String] = ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"]

let EvenOddWeeks : [String] = ["Нечётная неделя", "Чётная неделя"]

let MainStartTimes : [String] = ["7:30", "9:20", "11:10", "13:15", "15:00", "16:45", "18:30", "20:15"]

let MainStopTimes : [String] = ["9:05", "10:55", "12:45", "14:50", "16:35", "18:20", "20:05", "21:50"]

let SStartTimes : [String] = ["8:00", "9:45", "11:35", "13:40", "15:25", "17:10", "18:55", "20:40"]

let SStopTimes : [String] = ["9:35", "11:20", "13:10", "15:15", "17:00", "18:45", "20:30", "22:15"]
