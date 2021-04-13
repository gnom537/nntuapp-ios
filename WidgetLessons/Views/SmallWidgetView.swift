//
//  SmallWidgetView.swift
//  WidgetLessonsExtension
//
//  Created by Дмитрий Юдин on 06.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Small Widget

struct smallWidget: View {
    let widgetData: SmallWidgetData?
    let progressBar: ProgressBar?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if widgetData != nil {
//              MARK:- Current Lesson
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
//                      MARK: Room
                        
                        HStack (spacing: 2) {
                            if widgetData!.showedLesson!.rooms.count != 0 {
                                Text(widgetData!.showedLesson!.rooms[0].uppercased())
                                    .font(Font.system(size: 9, weight: .bold, design: .default))
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .truncationMode(.middle)
                                
                                
                                if widgetData!.showedLesson!.rooms.count >= 2 {
                                    Text(widgetData!.showedLesson!.rooms[1])
                                        .font(Font.system(size: 9, weight: .bold, design: .default))
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                }
                                
                                Spacer()
                            }
                        }
                        
//                      MARK:  Type
                        if (widgetData!.showedLesson!.rooms.count != 0 && (widgetData!.showedLesson!.rooms[0].count >= 10 || widgetData!.showedLesson!.rooms.count > 2)) {
                            Text(shortType(widgetData!.showedLesson!.type).uppercased())
                                .font(Font.system(size: 9, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        } else {
                            Text(widgetData!.showedLesson!.type.uppercased())
                                .font(Font.system(size: 9, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                       
                        Spacer()
                        
                        
//                      MARK: Counter or Day
                        if widgetData!.isToday {
                            Text(widgetData!.counter)
                                .font(Font.system(size: 9, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        else {
                            Text(normalShortDayOfWeek[widgetData!.showedLesson!.day].uppercased())
                                .font(Font.system(size: 9, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .lineLimit(1)
                        }
                    }
                    
//                  MARK:Current Lesson Name
                    Text(widgetData!.showedLesson!.name)
                        .fontWeight(.semibold)
                        .lineLimit(3)
                        .minimumScaleFactor(0.6)
                        .truncationMode(.middle)
                    
                    Spacer()
                    
//                  MARK: Additional teacher
                    if widgetData!.nextLesson == nil {
                        Text(widgetData!.showedLesson!.teacher)
                            .fontWeight(.semibold)
                            .font(.caption)
                            .truncationMode(.tail)
                            .lineLimit(2)
                        
                    }
                    
//                  MARK: Progress Bar
                    
                    VStack (spacing: 2) {
                        ZStack(alignment: .leading) {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: geo.size.width, height: 13)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                                
                                if progressBar != nil {
                                    RoundedRectangle(cornerRadius: 6)
                                        .frame(width: min(geo.size.width * progressBar!.percent, geo.size.width), height: 13)
                                        .animation(.spring())
                                        .foregroundColor(.green)
                                }
                                
                            }.frame(height: 13)
                        }.padding(0)
                        
                        
                        HStack {
                            Text(widgetData!.showedLesson!.startTime)
                                .font(Font.system(size: 9, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            
                            Spacer()
                            
                            Text(widgetData!.showedLesson!.stopTime)
                                .font(Font.system(size: 9, weight: .bold, design: .default))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        
                    }
                    
                    
                }.padding(12)
                .background(Color.init(UIColor.systemBackground).cornerRadius(20))
                
                
//          MARK:- Next Lesson if it avaliable
                if widgetData!.nextLesson != nil {
                    VStack (alignment: .leading) {
                        HStack (spacing: 0) {
//                          MARK: Rooms
                            HStack (spacing: 3) {
                                if widgetData!.nextLesson!.rooms.count != 0 {
                                    Text(widgetData!.nextLesson!.rooms[0])
                                        .font(Font.system(size: 9, weight: .bold, design: .default))
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                        .truncationMode(.middle)
                                    
                                    if widgetData!.nextLesson!.rooms.count >= 2 {
                                        Text(widgetData!.nextLesson!.rooms[1])
                                            .font(Font.system(size: 9, weight: .bold, design: .default))
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.7)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                            
//                          MARK: Type
                            if (widgetData!.nextLesson!.rooms.count == 0  || (widgetData!.nextLesson!.rooms.count < 2 &&  widgetData!.nextLesson!.rooms[0].count < 10)) {
                                Text(widgetData!.nextLesson!.type.uppercased())
                                    .font(Font.system(size: 9, weight: .bold, design: .default))
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            else {
                                Text(shortType(widgetData!.nextLesson!.type).uppercased())
                                    .font(Font.system(size: 9, weight: .bold, design: .default))
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            
                            Spacer()
//                          MARK: Counter
                            if (widgetData!.counter.incrementIndex() != "") {
                                Text(widgetData!.counter.incrementIndex())
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 9, weight: .bold, design: .default))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                        }
//                      MARK: Next Lesson name
                        Text(widgetData!.nextLesson!.name)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .truncationMode(.middle)
                        
                    }.padding([.trailing, .leading], 12)
                    .padding(.bottom, 6)
                }
            } else {
//              empty timetable
                VStack (alignment: .center) {
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "minus.magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                    Text("Расписание не найдено")
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.gray)
                        .padding(5)
                       
                    
                    Spacer()
                    
                }.background(Color.init(UIColor.systemBackground))
               
                
            }
        }.background(Color.secondary.opacity(0.2))
    }
}

