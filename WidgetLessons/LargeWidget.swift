//
//  LargeWidget.swift
//  WidgetLessonsExtension
//
//  Created by Дмитрий Юдин on 27.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct LargeWidget: View {
    let lessons: Lesson
    var body: some View {
        VStack {
            inactiveLesson(lesson: lessons)
            inactiveLesson(lesson: lessons)
            inactiveLesson(lesson: lessons)
            currentLesson(lesson: lessons)
                .frame(height: 70)
            inactiveLesson(lesson: lessons)
            inactiveLesson(lesson: lessons)

        }
    }
}

struct LargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidget(lessons: Lesson(startTime: "9:45", stopTime: "11:20", day: 0, weeks: [0], rooms: ["6155", "6666"], name: "Математичекий анализ", type: "Лекция", teacher: "Ерофеева Лариса Николаевна", notes: "2 подгруппа")).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct currentLesson: View {
    let lesson: Lesson
    var body: some View {
        VStack (alignment: .leading) {
            HStack (alignment: .top, spacing: 3) {
                ForEach(lesson.rooms, id: \.self) { room in
                    Text(room)
                        .font(.callout)
                        .minimumScaleFactor(0.7)
                }.padding(3)
                
                Spacer()
            }
            
            Spacer()
            
            Text(lesson.name)
                .fontWeight(.semibold)
                .padding([.leading, .trailing], 3)
            
            Spacer()
            
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100, height: 15)
            }
            
        }.background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding([.leading, .trailing], 7)
    }
}

struct inactiveLesson: View {
    let lesson: Lesson
    var body: some View {
        HStack (alignment: .center){
            VStack (alignment: .leading) {
                Text(lesson.startTime)
                Text(lesson.stopTime)
            }.font(.caption)
            .padding([.leading, .trailing], 7)
            
            Text(lesson.name + lesson.name + lesson.name + lesson.name)
                .font(.callout)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            
            VStack {
                ForEach(lesson.rooms, id: \.self) { room in
                    Text(room)
                }.font(.caption)
            }
            
            Spacer()
        }.padding(.bottom, 4)
    }
}
