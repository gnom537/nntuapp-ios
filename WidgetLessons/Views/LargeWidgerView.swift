//
//  LargeWidgerView.swift
//  WidgetLessonsExtension
//
//  Created by Дмитрий Юдин on 05.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: LargeWidget
struct LargeWidget: View {
    let lessons: [Lesson]
    let currentLessonIndex: Int
    let date: Date
    let barController: (percent: CGFloat, isActive: Bool)
    
    var body: some View {
        VStack {
            ForEach(0 ..< lessons.count) { index in
                if index == currentLessonIndex {
                    currentLesson(lesson: lessons[index], barController: barController, index: index, count: lessons.count, date: date)
                        .animation(.spring())
                }
                else {
                    inactiveLesson(lesson: lessons[index])
                        .animation(.spring())
                }
            }
            
            Spacer()
            
            if (lessons.count == 0) {
//               empty day or error
                Text("Сегодня пар нет?")
                    .foregroundColor(.secondary)
                Spacer()
            } else if (lessons.count < 3) {
                Text("Тут так много места, как в космосе")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
        }.padding([.top, .bottom], 5)
    }
}

// MARK: Current Lesson
struct currentLesson: View {
    let lesson: Lesson
    var barController: (percent: CGFloat, isActive: Bool)
    var index: Int
    var count: Int
    var date: Date
    
    var body: some View {
        VStack (alignment: .leading) {
//          Rooms
            HStack (alignment: .top, spacing: 3) {
                ForEach(lesson.rooms, id: \.self) { room in
                    Text(room)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.7)
                    
                }.padding([.leading, .top], 5)
                
            }
            
//          Name
            Text(lesson.name)
                .fontWeight(.semibold)
                .padding([.leading, .trailing], 5)
            
//          Teacher and more information
            Text(lesson.teacher)
                .padding([.leading, .trailing], 5)
                .font(.caption)
            
            Spacer()
            
//          Progress bar and time
            GeometryReader { geo in
                LazyHStack {
                    VStack (spacing: 0) {
                        Spacer()
//                      start and stop time
                        HStack {
                            Text(lesson.startTime)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(lesson.stopTime)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                        }.padding([.leading, .trailing], 5)
                        
//                      progress bar
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: geo.size.width/2 - 10, height: 15)
                                .padding([.top, .trailing], 3)
                                .padding(.leading, 5)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                            
                            if barController.isActive {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: min((geo.size.width/2 - 10) * barController.percent, geo.size.width / 2 - 10), height: 15)
                                    .padding([.top, .trailing], 3)
                                    .padding(.leading, 5)
                                    .padding(.bottom, 10)
                                    .animation(.spring())
                                    .foregroundColor(.green)
                            }
                            
                        }
                        
                    }
                    
//                  remaining time and count of lesson
                    VStack (alignment: .trailing) {
                        Spacer()
//                      count of lesson
                        HStack {
                            Text("\(index + 1)/\(count)")
                                .fontWeight(.semibold)
                                .foregroundColor( (index + 1) == count ? .green : .secondary)
                        }
//                      remaining time
//                      TODO: Добавить прогресс бар сюда 
                        Text("Время посчтитать")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .frame(height: 15)
                        
                    }.frame(width: geo.size.width/2 - 10)
                    .padding([.bottom, .trailing], 10)
                }
            }.padding(.bottom, 5)

            
        }.cornerRadius(10)
        .background(Color.init(UIColor.systemBackground).cornerRadius(10).shadow(radius: 5))
        .padding(7)
        .frame(minHeight: 113, idealHeight: 120, maxHeight: 180)
        
    }
}

// MARK: Inactive Lesson
struct inactiveLesson: View {
    let lesson: Lesson
    var body: some View {
        HStack (alignment: .center){
            VStack (alignment: .leading) {
                Text(lesson.startTime)
                Text(lesson.stopTime)
            }.font(.caption)
            .frame(width: 40)
            .padding([.leading, .trailing], 7)
            .minimumScaleFactor(0.9)

            
            Text(lesson.name)
                .font(.callout)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            
            Spacer()
            
            VStack (alignment: .trailing) {
                ForEach(lesson.rooms, id: \.self) { room in
                    Text(room)
                }.font(.caption)
            }.padding(.trailing, 7)
            
        }.padding(.bottom, 4)
    }
} 
