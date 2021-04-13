//
//  SupportFunction.swift
//  WidgetLessonsExtension
//
//  Created by Дмитрий Юдин on 05.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import UIKit




//MARK:  function for move of lessons. return 4 lessons
func moveLesson(lessons: [Lesson], index: Int) ->  (lessons: [Lesson], newIndex: Int) {
    
    var result: (lessons: [Lesson], newIndex: Int) = ([Lesson](), 0)
    
    if lessons.count < 5 {
        result.lessons = lessons
        result.newIndex = index
    }
    else {
        if (index + 4) <= lessons.count {
            for i in index...index+3 {
                result.lessons.append(lessons[i])
                result.newIndex = 0
            }
        } else {
            //          how lessons after current lesson + current lesson
            let different = lessons.count - index
            
            
            switch different {
            case 1:
                for i in (index - 3)...index {
                    result.lessons.append(lessons[i])
                }
                result.newIndex = 3
                
            case 2:
                for i in (index - 2)...index + 1 {
                    result.lessons.append(lessons[i])
                }
                result.newIndex = 2
                
            case 3:
                for i in (index - 1)...index + 2 {
                    result.lessons.append(lessons[i])
                }
                result.newIndex = 1
                
            default:
                return result
            }
            
        }
    }
    
    return result
}



// MARK: - ProgressBar
struct ProgressBar {
    var percent: CGFloat = 0
    var leftTimeString = ""
    
}

// MARK: Get Data for Progress Bar
func getProgressBarData(lesson: Lesson, date: Date) -> ProgressBar? {
    var progressBar: ProgressBar
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    let currentTime = dateFormatter.string(from: date)
    let startTime = dateStringToInt(time: lesson.startTime)
    let currentTimeInt = dateStringToInt(time: currentTime)
    
    if startTime > currentTimeInt {
        //      Пара еще не началась
        let different = calculateDates(timeStart: currentTime, timeEnd: lesson.startTime)!
        if different < 60 {
            let timingBeforeLesson = getProgressBarLabelBeforeLesson(different: different)
            progressBar = ProgressBar(percent: 0, leftTimeString: timingBeforeLesson)
        }
        progressBar = ProgressBar(percent: 0, leftTimeString: "")
    } else {
        //     Пара началась
        let different = calculateDates(timeStart: lesson.startTime, timeEnd: lesson.stopTime)!
        let leftTime = getProgressBarInTime(different: different)
        let percent = max(0, min(1, getPercent(timeStart: lesson.startTime,
                                               timeEnd: lesson.stopTime,
                                               date: Date())))
        progressBar = ProgressBar(percent: percent, leftTimeString: leftTime)
    }
    return progressBar
}

// Время до пары
func getProgressBarLabelBeforeLesson(different: Int) -> String {
    switch different % 10 {
    case 1:
        return "До пары: \(different) минута"
    case 2...4:
        return "До пары: \(different) минуты"
    case 0, 5...9:
        return "До пары: \(different) минут"
    default:
        return "До пары: \(different) минута"
    }
}

// Время до конца пары
func getProgressBarInTime(different: Int) -> String {
    if different >= 60 {
        let hours = "\(Int(different/60)) ч."
        let minutes = {
            return different % 60 == 0 ? "" : " \(different % 60) мин."
        }()
        return hours + minutes
    } else {
        switch different % 10 {
        case 1:
            return "Осталось: \(different) минута"
        case 2...4:
            return "Осталось: \(different) минуты"
        case 0, 5...9:
            return "Осталось: \(different) минут"
        default:
            return "Осталось: \(different) минута"
        }
    }
}

// Проценты
func getPercent(timeStart: String, timeEnd: String, date: Date) -> CGFloat {
    let timeLesson = calculateDates(timeStart: timeStart, timeEnd: timeEnd)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    let currentTime = dateFormatter.string(from: date)
    
    let goingTime = calculateDates(timeStart: timeStart, timeEnd: currentTime)
    if timeLesson != nil && goingTime != nil {
        let percent = CGFloat(goingTime!) / CGFloat(timeLesson!)
        
        return percent
    }
    
    return 0
}
