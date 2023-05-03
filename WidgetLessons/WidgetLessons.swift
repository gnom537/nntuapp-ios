//
//  WidgetLessons.swift
//  WidgetLessons
//
//  Created by Дмитрий Юдин on 27.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import WidgetKit
import SwiftUI


//MARK:- Timeline Provider
struct Provider: TimelineProvider {
    
//  MARK: Placeholder
    func placeholder(in context: Context) -> WidgetEntry {
        let smallWidgetData = SmallWidgetData(showedLesson: previewData.testLesson, nextLesson: previewData.testLesson, counter: "1/2")
        let progressBar = ProgressBar(percent: 43, leftTimeString: "")
        
        print("PLACEHOLDER")
        return (WidgetEntry(date: Date(), smallWidgetData: smallWidgetData, progressBar: progressBar))
    }
//  MARK: Snapshot
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let currentDate = Date()
        let lessons = CoreDataStack.shared.fetchLessons()
        print("SNAPSHOT")
        if lessons.count != 0 {
            let todayLessons = CoreDataStack.shared.getSortedLessons(lessons: lessons, day: getCurrentDay(), week: getCurrentWeek())
            
            guard todayLessons != nil, let index: Int = getIndexLesson(lessons: todayLessons!, date: currentDate) else {
                
                //              Если пары закончились или пар в этот день нет
                guard let nearestLesson: [Lesson] = CoreDataStack.shared.getNearLessons(lessons: lessons) else {
                    //                  Пар нет вообще. Возвращаем пустую entry
                    let entry = WidgetEntry(date: currentDate, smallWidgetData: nil, progressBar: nil)
                    print(entry)
                    completion(entry)
                    return
                }
                //                  Если когда-то пары все таки есть
                let nextLesson = nearestLesson.count > 1  ? nearestLesson[1] : nil
                let smallWidgetData = SmallWidgetData(showedLesson: nearestLesson[0], nextLesson: nextLesson, isToday: false)
                let entry = WidgetEntry(date: currentDate, smallWidgetData: smallWidgetData, progressBar: nil)
                print(entry)
                completion(entry)
                return
            }
            
            //                  Пары сегодня есть
            var nextLesson: Lesson?
            
            if index + 1 < todayLessons!.count {
                nextLesson = todayLessons![index + 1]
            }
            let counter = "\(index + 1)/\(todayLessons!.count)"
            let smallWidgetData = SmallWidgetData(showedLesson: todayLessons![index],
                                                  nextLesson: nextLesson,
                                                  counter: counter)
            let progressBar = getProgressBarData(lesson: todayLessons![index], date: currentDate)
            let entry = WidgetEntry(date: currentDate, smallWidgetData: smallWidgetData, progressBar: progressBar)
            print(entry)

            completion(entry)         
        } else {
            //          Количество пар в кор дате == 0
            completion(WidgetEntry(date: currentDate, smallWidgetData: nil, progressBar: nil))
        }
    }
    
//  MARK: TimeLine
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []
        
        let lessons = CoreDataStack.shared.fetchLessons()
        if lessons.count != 0{
            for minutesOffset in 0 ..< 10 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minutesOffset, to: Date())!
                let todayLessons = CoreDataStack.shared.getSortedLessons(lessons: lessons, day: getCurrentDay(date: entryDate), week: getCurrentWeek(date: entryDate))
                var index: Int?
                if todayLessons != nil {
                    index = getIndexLesson(lessons: todayLessons!, date: entryDate)
                }
                
                if index == nil {
                    //              Если пары закончились или пар в этот день нет
                    guard let nearestLesson: [Lesson] = CoreDataStack.shared.getNearLessons(lessons: lessons) else {
                        //                  Пар нет вообще. Возвращаем пустую entry
                        
                        let entry = WidgetEntry(date: entryDate, smallWidgetData: nil, progressBar: nil)
                        entries.append(entry)
                        
                        let timeline = Timeline(entries: entries, policy: .atEnd)
                        print("\(minutesOffset):  nil")
                        completion(timeline)
                        return
                    }
                    //                  Если когда-то пары все таки есть
                    let nextLesson = nearestLesson.count > 1  ? nearestLesson[1] : nil
                    let counter = "1/\(nearestLesson.count)"
                    let smallWidgetData = SmallWidgetData(showedLesson: nearestLesson[0], nextLesson: nextLesson, isToday: false, counter: counter)
                    let entry = WidgetEntry(date: entryDate, smallWidgetData: smallWidgetData, progressBar: nil)
                    print("\(minutesOffset):  small: \(smallWidgetData)")
                    entries.append(entry)
                    
                } else {
                    //                  Пары сегодня есть
                    var nextLesson: Lesson?
                    
                    if index! + 1 < todayLessons!.count {
                        nextLesson = todayLessons![index! + 1]
                    }
                    let counter = "\(index! + 1)/\(todayLessons!.count)"
                    let smallWidgetData = SmallWidgetData(showedLesson: todayLessons![index!],
                                                          nextLesson: nextLesson,
                                                          counter: counter)
                    let progressBar = getProgressBarData(lesson: todayLessons![index!], date: entryDate)
                    print("\(minutesOffset):  small: \(smallWidgetData)")
                    let entry = WidgetEntry(date: entryDate, smallWidgetData: smallWidgetData, progressBar: progressBar)
                    entries.append(entry)
                }
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            
        } else {
            //          Количество пар в кор дате == 0
            let entry = WidgetEntry(date: Date(), smallWidgetData: nil, progressBar: nil)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

// MARK:- Entry
struct WidgetEntry: TimelineEntry {
    let date: Date
    let smallWidgetData: SmallWidgetData?
    let progressBar: ProgressBar?
    //
    //
    //    let lessons: [Lesson]
    //    let lesson: Lesson?
    //    let nextLesson: Lesson?
    //    let indexLesson: Int
    //    let progressBar: (percent: CGFloat, isActive: Bool)
    //    let offset: Int
    //    let fourLessons: (lessons: [Lesson], newIndex: Int)
}
// MARK: Entry View
struct WidgetLessonsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget(widgetData: entry.smallWidgetData, progressBar: entry.progressBar)
                .widgetURL(URL(string: "nntu.openTimeTable"))
            
        //        case .systemMedium:
        //            MediumWidget(lesson: entry.lesson, lessons: entry.lessons, progress: entry.progressBar, index: entry.indexLesson, count: entry.lessons.count, fourDisplay: entry.fourLessons, date: entry.date)
        //                .widgetURL(URL(string: "openTimeTable"))
        //
        //        case .systemLarge:
        //            LargeWidget(lessons: entry.lessons ,currentLessonIndex: entry.indexLesson, date: entry.date, barController: entry.progressBar)
        //                .widgetURL(URL(string: "openTimeTable"))
        
        default:
            Text("??")
        }
    }
}



// MARK: Widget

@main
struct WidgetLessons: Widget {
    let kind: String = "WidgetLessons"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetLessonsEntryView(entry: entry)
        }
        .configurationDisplayName("Расписание НГТУ")
        .supportedFamilies([.systemSmall])
        .description("Расписание прямо на рабочем столе.")
    }
}

//MARK:- Preview

struct WidgetLessons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetLessonsEntryView(entry: WidgetEntry(date: Date(), smallWidgetData: SmallWidgetData(showedLesson: previewData.testLesson, nextLesson: previewData.testLesson), progressBar: ProgressBar(percent: 43, leftTimeString: "")))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                //            WidgetLessonsEntryView(entry: WidgetEntry(date: Date(), lessons: previewData.lessons, lesson: previewData.testLesson, nextLesson: previewData.testLesson, indexLesson: 1, progressBar: (0.4, true), offset: 0, fourLessons: previewData.fourLessons))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            //            WidgetLessonsEntryView(entry: WidgetEntry(date: Date(), lessons: previewData.lessons, indexLesson: 3))
            //                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

//MARK: Preview Data
struct previewData {
    static let testLesson = Lesson(startTime: "9:45", stopTime: "10:40", day: 4, weeks: [1,2], rooms: ["6255", "6125"], name: "Формальные языки программирования", type: "лекция", teacher: "Кольчик Ирина Викторовна", notes: "Это заметка")
    static let lesson = [testLesson]
    static let lessons = Array(repeating: testLesson, count: 5)
    static let fourLessonsArray = Array(repeating: testLesson, count: 4)
    static let fourLessons = (lessons: fourLessonsArray, newIndex: 1)
    
}



extension String {
    func incrementIndex() -> String {
        if self.count > 1 {
            let string = self
            let indexArray = string.components(separatedBy: "/")
            let firstElementOfIndex = Int(indexArray[0]) ?? 0
            
            return "\(firstElementOfIndex + 1)/\(indexArray[1])"
        }
        return ""
    }
}
