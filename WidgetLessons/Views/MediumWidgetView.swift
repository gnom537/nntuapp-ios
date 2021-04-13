//
//  MediumWidgetView.swift
//  WidgetLessonsExtension
//
//  Created by Дмитрий Юдин on 08.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Main
struct MediumWidget: View {
    
    let lesson: Lesson?
    let lessons: [Lesson]
    let progress: (percent: CGFloat, isActive: Bool)
    let index: Int
    let count: Int
    let fourDisplay: (lessons: [Lesson], newIndex: Int)
    let date: Date
    
    var body: some View {
        
        if lesson == nil {
//          TimeTable is empty
            VStack (alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "minus.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundColor(.gray)
                    
                    Text("Расписание не найдено")
                        .font(.callout)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.gray)
                }
   
            }
            
        }
        else {
            GeometryReader { geo in
                HStack {
                    CurrentLessonMedium(lesson: lesson!, progress: progress, index: index, count: count, date: date)
                        .frame(width: geo.size.width/2)
                    
                    
                    VStack (alignment: .leading, spacing: 0) {
                        
                        Spacer().frame(height: 5)
                        
                        if lessons.count < 5 {
                            ForEach(0..<lessons.count, id: \.self) { i in
                                if i == index {
                                    InactiveMedium(isSelected: true, isNext: false, lesson: lessons[i], isLast: index == lessons.count - 1)
                                }
                                else if (i == (index + 1)) {
                                    InactiveMedium(isSelected: false, isNext: true, lesson: lessons[i], isLast: index == lessons.count - 1)
                                }
                                else {
                                    InactiveMedium(isSelected: false, isNext: false, lesson: lessons[i], isLast: index == lessons.count - 1)
                                }
                                
                            }
                            
                        }
                        else {
                            ForEach(0..<fourDisplay.lessons.count, id: \.self) { i in
                                if i == fourDisplay.newIndex {
                                    InactiveMedium(isSelected: true, isNext: false, lesson: fourDisplay.lessons[i], isLast: i == fourDisplay.lessons.count - 1)
                                }
                                else if (i == (fourDisplay.newIndex + 1)) {
                                    InactiveMedium(isSelected: false, isNext: true, lesson: fourDisplay.lessons[i], isLast: i == fourDisplay.lessons.count - 1)
                                }
                                else {
                                    InactiveMedium(isSelected: false, isNext: false, lesson: fourDisplay.lessons[i], isLast: i == fourDisplay.lessons.count - 1)
                                }
                            }
                        }
                        
                        
                        Spacer()
                    }.frame(width: geo.size.width/2, height: geo.size.height )
                    .background(Color.secondary.opacity(0.2))
                    
                    
                    
                    
                }
            }
        }
        
    }
}
  


// MARK:- Current Lesson
struct CurrentLessonMedium: View {
    
    let lesson: Lesson
    let progress: (percent: CGFloat, isActive: Bool)
    let index: Int
    let count: Int
    let date: Date
    
    var body: some View {
        VStack (alignment: .leading, spacing: 1) {
//          MARK: Rooms and counter
            HStack {
                HStack (spacing: 3) {
                    ForEach(lesson.rooms, id: \.self) { room in
                        Text(room)
                            .font(Font.system(size: 10, weight: .bold, design: .default))
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text("\(index + 1)/\(count)")
                    .font(Font.system(size: 10, weight: .bold, design: .default))
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }
//          MARK: Lesson Name
            Text(lesson.name)
                .font(Font.system(size: 14, weight: .bold, design: .default))
                .lineLimit(4)
                .truncationMode(.middle)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
//          MARK: Teacher if it availiable
            if !lesson.teacher.isEmpty {
                Text(lesson.teacher)
                    .font(Font.system(size: 10, weight: .bold, design: .default))
                    .lineLimit(2)
            }
//          MARK: Notes if it availiable
            if !lesson.notes.isEmpty {
                Text(lesson.notes)
                    .font(Font.system(size: 10, weight: .bold, design: .default))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(.gray)
            }
//          MARK: Progress Bar
            GeometryReader { geo in
                LazyHStack {
                    VStack (spacing: 0) {
//                      start and stop time
                        HStack {
                            Text(lesson.startTime)
                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                .lineLimit(1)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(lesson.stopTime)
                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                .lineLimit(1)
                                .foregroundColor(.gray)
                            
                        }
//                      progress bar
                        VStack (alignment: .trailing, spacing: 3) {
                            ZStack (alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: geo.size.width, height: 12)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                                
                                if progress.isActive {
                                    RoundedRectangle(cornerRadius: 6)
                                        .frame(width: min(geo.size.width, geo.size.width * progress.percent), height: 12)
                                        .animation(.spring())
                                        .foregroundColor(.green)
                                }
                            }
                            
//                          MARK: Remainig time
//                          TODO: прогресс бар сюда добавить 
                            Text("НУЖНО ПОСЧИТАТЬ ВРЕМЯ")
                                .lineLimit(1)
                                .font(Font.system(size: 10, weight: .bold, design: .default))
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                        }
                        
                    }
                
                }
            }.frame(height: 49)
        }.padding([.leading, .top], 13)
        .padding(.trailing, 6)
    }
}

//MARK:- Inactive lesson
struct InactiveMedium: View {
    let isSelected: Bool
    let isNext: Bool
    let lesson: Lesson
    let isLast: Bool
    
    var body: some View {
        VStack {
            Divider()
            
            Spacer()
            if isSelected {
                HStack {
                    Text(lesson.name + " (\(shortType(lesson.type)))")
                        .font(Font.system(size: 9, weight: .regular, design: .default))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 6)
                        .background(Color.init(UIColor.systemBackground).cornerRadius(5))
                        .shadow(radius: 6)
                        .truncationMode(.middle)
                    Spacer()
                }.padding(.leading, 7)
                .padding(.trailing, 4)
                .padding(.vertical, 5)
                
            }
            else {
                VStack (alignment: .leading) {
                    if isNext {
                        HStack (spacing: 2) {
                            if lesson.rooms.count != 0 {
                                Text("ДАЛЕЕ В \(lesson.startTime),")
                                    .font(Font.system(size: 8, weight: .bold, design: .default))
                                    .foregroundColor(.gray)
                            }
                            else {
                                Text("ДАЛЕЕ В \(lesson.startTime)")
                                    .font(Font.system(size: 8, weight: .bold, design: .default))
                                    .foregroundColor(.gray)
                            }
                            
                            HStack (spacing: 3) {
                                ForEach(lesson.rooms, id: \.self) { room in
                                    Text(room)
                                        .font(Font.system(size: 8, weight: .bold, design: .default))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    HStack {
                        Text(lesson.name + " (\(shortType(lesson.type)))")
                            .truncationMode(.middle)
                            .font(Font.system(size: 9, weight: .regular, design: .default))
                            .minimumScaleFactor(0.8)
                            .lineLimit(2)
                        
                        Spacer()
                    }
                }.padding(.leading, 7)
                .padding(.trailing, 4)
                
            }
            
            Spacer()
            
            Divider()
        }.frame(height: 40)
    }
}
