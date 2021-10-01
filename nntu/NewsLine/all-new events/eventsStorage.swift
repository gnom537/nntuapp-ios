//
//  eventsStorage.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 04.08.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI
import Alamofire

extension UIColor {
    public convenience init?(hex oldHex: String) {
        let hex = oldHex + "FF"
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}

extension UIImage {
    public convenience init?(base64: String?){
        if (base64 != nil){
            let dataDecoded : Data = Data(base64Encoded: base64!, options: .ignoreUnknownCharacters)!
            self.init(data: dataDecoded)
        } else {
            self.init()
        }
        
    }
}

struct event : Decodable {
    var color: UIColor = .black
    var author: String
    var type: String
    var title: String
    var description: String
    var startTime: Int?
    var stopTime: Int?
    var place: String?
    var imageLink: String?
    var links: [(String, String)]
    
    
    
    enum CodingKeys: String, CodingKey {
        case color
        case author
        case type
        case title
        case description
        case startTime
        case stopTime
        case place
        case imageLink = "image"
        case links
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let tempColor = try? container.decode(String.self, forKey: .color){
            self.color = UIColor(hex: tempColor) ?? .black
        }
        self.author = (try? container.decode(String.self, forKey: .author)) ?? ""
        self.type = (try? container.decode(String.self, forKey: .type)) ?? ""
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.startTime = (try? container.decode(Int.self, forKey: .startTime))
        self.stopTime = (try? container.decode(Int.self, forKey: .stopTime))
        self.place = (try? container.decode(String.self, forKey: .place))
        self.imageLink = (try? container.decode(String.self, forKey: .imageLink))
        self.links = []
        if let linksString = try? container.decode(String.self, forKey: .links){
            let tempLinks = linksString.components(separatedBy: ",")
            if tempLinks.count % 2 == 0 {
                for i in 0..<tempLinks.count where i % 2 == 0 {
                    self.links.append((tempLinks[i], tempLinks[i+1]))
                }
            }
        }
        clearFromEmptyStrings()
    }
    
    init (type: String, author: String, color: String, title: String, description: String, startTime: Int?, stopTime: Int?, place: String?, imageLink: String?, links: [(String, String)]) {
        self.color = UIColor(hex: color) ?? .black
        self.author = author
        self.type = type
        self.title = title
        self.description = description
        self.startTime = startTime
        self.stopTime = stopTime
        self.place = place
        self.imageLink = imageLink
//        self.image = UIImage(base64: image)
        self.links = links
    }
    
    init (from art: article) {
        self.color = .secondarySystemBackground
        self.author = "Новости НГТУ"
        self.type = "article"
        self.title = art.zag ?? ""
        self.description = art.text ?? art.href ?? ""
        self.startTime = nil
        self.stopTime = nil
        self.place = nil
        self.imageLink = art.preview
        self.links = []
        if let href = art.href {
            print(href)
            links.append(("Статья на сайте НГТУ", href))
        }
    }
    
    mutating func clearFromEmptyStrings(){
        if place == "" {place = nil}
        if imageLink == "" {imageLink = nil}
    }
    
    func showInCalendar(completition: @escaping (EKEventViewController?) -> (Void)){
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { granted, error in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                
                event.title = self.title
                let startDate = Date(timeIntervalSince1970: Double(min(self.startTime!, self.stopTime!))/1000)
                let endDate = Date(timeIntervalSince1970: Double(max(self.startTime!, self.stopTime!))/1000)
                event.startDate = startDate
                event.endDate = endDate
                event.notes = self.description
                if links.count > 0 {
                    if let url = URL(string: links[0].1){
                        event.url = url
                    }
                }
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent, commit: true)
                } catch let error {
                    print(error)
                }
                DispatchQueue.main.async {
                    let eventControler = EKEventViewController()
                    eventControler.event = event
                    completition(eventControler)
                }
            } else {
                DispatchQueue.main.async {
                    completition(nil)
                }
            }
        })
    }
}

struct manyEvents: Decodable{
    var data : [event]
}

func loadOldArticlesAsEvents(_ completition: @escaping ([event]) -> (Void)){
    loadOldArticles(completion: {html in
        let articles : [article] = scrapeOldArticles(html: html)
        let articlesAsEvents: [event] = articles.map({event(from: $0)})
        completition(articlesAsEvents)
    })
}

func loadEvents(_ completition: @escaping ([event]) -> (Void)){
    let url = URL(string: "http:/194.58.97.17:3001/")!
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    var output = [event]()

    let task = session.dataTask(with: request, completionHandler: {data, response, error in
        guard error == nil else {
            completition(output)
            return
        }
        guard let data = data else {
            completition(output)
            return
        }
        
        do {
            let decodedArray = try JSONDecoder().decode(manyEvents.self, from: data)
            output = decodedArray.data.sorted(by: {
                if let first = $0.startTime{
                    if let second = $1.startTime {
                        if $0.stopTime != nil && $1.stopTime == nil {
                            return true
                        } else if $0.stopTime == nil && $1.stopTime == nil{
                            return first > second
                        } else {return first < second}
                    }
                    return true
                }
                return true
            })
            completition(output)
        } catch let error {
            completition(output)
            print(error)
        }
    })

    task.resume()
}

//struct eventID : Hashable, Codable {
//    let value: Int
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(value)
//    }
//
//    static func == (lhs: eventID, rhs: eventID) -> Bool {
//        return lhs.value == rhs.value
//    }
//}

func updateLastID(_ completition: @escaping (Int)->(Void)) {
    DispatchQueue.global().async {
        guard let loadedID = getLastID() else {return}
        guard let existingID = savedID() else {
            saveID(loadedID)
            return
        }
        localID = loadedID
        if loadedID == existingID {return}
        DispatchQueue.main.async {
            completition(loadedID - existingID)
        }
    }
}

var localID : Int?

func savedID() -> Int? {
    let id = UserDefaults.standard.object(forKey: "lastID") as? Int
    return id
}

func saveID(_ id: Int){
    UserDefaults.standard.set(id, forKey: "lastID")
}

func updateBadge(_ vc: UIViewController){
    updateLastID { badgeValue in
        if let items = vc.tabBarController?.tabBar.items {
            let eventsTab = items[0]
            eventsTab.badgeValue = String(badgeValue)
        }
    }
}

func getLastID() -> Int? {
    let optIdString = try? String(contentsOf: lastIdURL)
    guard var idString = optIdString else {return nil}
    idString = idString.replacingOccurrences(of: "{\"lastID\":", with: "")
    idString = idString.replacingOccurrences(of: "}", with: "")
    return Int(idString)
}
