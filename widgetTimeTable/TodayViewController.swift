//
//  TodayViewController.swift
//  widgetNNTU
//
//  Created by Дмитрий Юдин on 26.07.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//
import Foundation
import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    
    func stringFromRooms(rooms: [String]) -> String{
        var tempRooms = ""
        if (rooms.count == 0 || rooms == [""]) {return ""}
        for j in (0 ... rooms.count - 1){
            tempRooms += rooms[j] + ","
        }
        return String(tempRooms.dropLast(1))
    }
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var StartTime: UILabel!
    @IBOutlet var NameNRoom: UILabel!
    @IBOutlet var StopTime: UILabel!
    @IBOutlet var Next: UILabel!
    @IBOutlet var bigView: UIView!
    @IBOutlet var bigStack: UIStackView!
    
    @IBOutlet var Names: [UILabel]!
    @IBOutlet var startTimes: [UILabel]!
    @IBOutlet var stopTimes: [UILabel]!
    @IBOutlet var auds: [UILabel]!
    @IBOutlet var bigDateDayLabel: UILabel!

    
//  MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lessons = CoreDataStack.shared.fetchLessons()
        var showLessons = CoreDataStack.shared.getTodayLessons()
        var twoLesson: (now: Lesson?, next: Lesson?) = (nil, nil)
        
        if showLessons != nil {
            twoLesson = CoreDataStack.shared.getTodayTwoLessons(lessons: showLessons!)
        }
    
        self.dayLabel.text = getTodayLabel()
        
        
//      MARK: Small View
        if showLessons == nil {
//          If not founded lessons today
            let nearResult = CoreDataStack.shared.getNearLessons(lessons: lessons)
            
            if nearResult != nil {
                showLessons = nearResult!
                twoLesson = CoreDataStack.shared.getTwoNearLessons(lessons: showLessons!)
                
                let nowLesson = twoLesson.now!
                
                self.dayLabel.text = "Расписание на \(DaysOfWeek[nowLesson.day].lowercased())"
                
                StartTime.text = nowLesson.startTime
                //тут Дима забыл указать аудиторию
//                if nowLesson.type.isEmpty {
//                    NameNRoom.text = nowLesson.name
//                }
//                else {
//                    NameNRoom.text = nowLesson.name + " (\(shortType(nowLesson.type)))"
//                }
                
                var tempString = nowLesson.name
                if (!nowLesson.type.isEmpty){
                    tempString += ", \(shortType(nowLesson.type))"
                }
                if (nowLesson.rooms.count > 0){
                    tempString += ", \(stringFromRooms(rooms: nowLesson.rooms))"
                }
                NameNRoom.text = tempString
                
                StopTime.text = nowLesson.stopTime
                
                if twoLesson.next == nil {
                    Next.text = "В этот день больше пар нет"
                }
                else {
                    let nextLesson = twoLesson.next!
                    var timeString: String
                    var roomString: String
                    
                    if !nextLesson.startTime.isEmpty {
                        timeString = " в \(nextLesson.startTime)"
                    }
                    else {
                        timeString = ""
                    }
                    
                    if nextLesson.rooms.count != 0 {
                        roomString = ", \(nextLesson.rooms[0])"
                    }
                    else {
                        roomString = ""
                    }
                    
                    Next.text = "Далее: " + nextLesson.name + roomString + timeString
                }
            }
            else {
                self.NameNRoom.text = "К сожалению, мы не нашли Вашего расписания"
                self.Next.text = "Попробуйте добавить его в редакторе"
            }
            
        }
        else {
            let nowLesson = twoLesson.now!
            
            StartTime.text = nowLesson.startTime
            //тут тоже забыл
//            if nowLesson.type.isEmpty {
//                NameNRoom.text = nowLesson.name
//            }
//            else {
//                NameNRoom.text = nowLesson.name + " (\(shortType(nowLesson.type)))"
//            }
            
            var tempString = nowLesson.name
            if (!nowLesson.type.isEmpty){
                tempString += ", \(shortType(nowLesson.type))"
            }
            if (nowLesson.rooms.count > 0){
                tempString += ", \(stringFromRooms(rooms: nowLesson.rooms))"
            }
            NameNRoom.text = tempString
            
            StopTime.text = nowLesson.stopTime
            
            if twoLesson.next == nil {
                Next.text = "Сегодня пар больше нет"
            }
            else {
                let nextLesson = twoLesson.next!
                var timeString: String
                var roomString: String
                
                if !nextLesson.startTime.isEmpty {
                    timeString = " в \(nextLesson.startTime)"
                }
                else {
                    timeString = ""
                }
                
                if nextLesson.rooms.count != 0 {
                    roomString = " \(nextLesson.rooms[0])"
                }
                else {
                    roomString = ""
                }
                
                Next.text = "Далее: " + nextLesson.name + roomString + timeString
            }
            
        }
        
//      MARK: Big View 
        if showLessons != nil {
            for i in 0..<showLessons!.count {
                let lesson = showLessons![i]
                
                startTimes[i].text = lesson.startTime
                stopTimes[i].text = lesson.stopTime
                
                if lesson.type.isEmpty {
                    Names[i].text = lesson.name
                }
                else {
                    Names[i].text = lesson.name + " (\(shortType(lesson.type)))"
                }
                
                if lesson.rooms.count != 0 {
                    auds[i].text = lesson.rooms[0]
                }
            }
        }
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    
    
//  MARK: Footer for expanded widget
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            let genator = UIImpactFeedbackGenerator(style: .light)
            genator.impactOccurred()
            UIView.animate(withDuration: 1, animations: {
                self.bigView.isHidden = true
                self.view.layoutIfNeeded()
                self.preferredContentSize = maxSize
            })
            UIView.animate(withDuration: 0.8, animations: {
                self.bigStack.alpha = 0
            })
            UIView.animate(withDuration: 5, animations: {
                self.bigView.alpha = 0
            })
        } else if activeDisplayMode == .expanded {
            let genator = UIImpactFeedbackGenerator(style: .light)
            genator.impactOccurred()
            self.preferredContentSize = CGSize(width: maxSize.width, height: 430)
            UIView.animate(withDuration: 0.5, animations: {
                self.bigView.isHidden = false
            })
            UIView.animate(withDuration: 1, animations: {
                self.bigStack.alpha = 1
            })
            UIView.animate(withDuration: 0.2, animations: {
                self.bigView.alpha = 1
            })
        }
    }
}


