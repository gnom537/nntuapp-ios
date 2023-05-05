//
//  DataStorage.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 19.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

let marksURL: URL = URL(string: "https://www.nntu.ru/frontend/web/student_info.php")!

// used in AF request
let newsURL: URL = URL(string: "https://www.nntu.ru/news/all/vse-novosti")!

var Globaldata : TimeTable? = TimeTable()

var tabBarVCs: [UIViewController]?
var entered = false


var PreLoadedRoom: String? = nil
var ControllerToUpdate : UIViewController? = nil

let BUNDLEGROUP = "group.nntu.share"


//MARK: - widgetAssistent
    let widgetUserDefaults = UserDefaults(suiteName: BUNDLEGROUP)
    var currentTimeOnWidget = widgetUserDefaults?.integer(forKey: "widgetUpd") ?? 0
    
//MARK: - Article struct
struct article {
    var preview, zag, href, text, hqimage: String?
    var HQimage, Preview: UIImageView?
}


//MARK: - Mark Structures
struct Dis {
    var Name : String
    var FirstKn : String?
    var PropFirstKn: String?
    var SecondKn : String?
    var PropSecondKn : String?
    var ResType : String
    var Result : String?
    
    init(Name: String?, FirstKn: String?, PropFirstKn: String?, SecondKn: String?, PropSecondKn: String?, ResType: String?, Result: String?) {
        self.Name = Name ?? ""
        self.FirstKn = FirstKn
        self.PropFirstKn = PropFirstKn
        self.SecondKn = SecondKn
        self.PropSecondKn = PropSecondKn
        self.ResType = ResType ?? ""
        self.Result = Result
        
        if (FirstKn == "") {self.FirstKn = nil}
        if (SecondKn == "") {self.SecondKn = nil}
        if (Result == "") {self.Result = nil}
    }
    
    func hasResult() -> Bool {
        return FirstKn != nil || SecondKn != nil || Result != nil
    }
}

struct Sem {
    var Semestr = [Dis]()
    var number = 0
    
    func hasMarks() -> Bool {
        for mark in self.Semestr {
            if mark.hasResult() {return true}
        }
        return false
    }
    
    func isEmpty() -> Bool {
        return Semestr.isEmpty
    }
}

struct multipleSems {
    var Sems = [Sem]()
}


//MARK: - TimeTable Structure

struct DisTime {
    var Name, Aud, StartTime, StopTime : String?
    var Number : Int?
}

struct Day {
    var Paras = [DisTime?](repeating: DisTime(), count: 8)
}

struct Week {
    var Days = [Day?](repeating: Day(), count: 6)
}

class TimeTable {
    var TimeTable = [Week?](repeating: Week(), count: 2)
}



//MARK: - getInfoFromNet()
func loadOldArticles (completion: @escaping (String?)->(Void)){
  var request = URLRequest(url: newsURL)
  request.method = .get
  request.setValue("keep-alive", forHTTPHeaderField: "Connection")
  request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64)", forHTTPHeaderField: "User-Agent")

  URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
      print("Старые статьи не были загиружены")
      DispatchQueue.main.async {
        completion(nil)
      }
    return
    }

    let html = String(data: data, encoding: .utf8) ?? ""
    DispatchQueue.main.async {
      completion(html)
    }
  }.resume()
}


//MARK: - scrape()
func scrapeOldArticles (html : String?) -> Array<article>{
        var preview, zag, href, text, hqimage: String?
        var webcontent: String = html ?? "  "
        var news = [article]()
        let previewStartWord = """
<img alt=""\n                                                                         src="
"""
        let previewStopWord = """
"/>
"""
//    <a class="item-link is-popover" href="
        let hrefStartWord = """
<a class="item-link is-popover"\n                                                                       href="
"""
        let hrefStopWord = """
"\n
"""
        let zagStartWord = """
data-content="">
"""
        let zagStopWord = """
</a>
"""
        while (webcontent.contains(previewStartWord) == true){
            //PreviewImage
            if let prevStartRange = webcontent.range(of: previewStartWord){
                let StartIngex = prevStartRange.upperBound
                webcontent = String(webcontent.suffix(from: StartIngex))
                if let prevStopRange = webcontent.range(of: previewStopWord){
                    let stopIndex = prevStopRange.lowerBound
                    preview = String(webcontent.prefix(upTo: stopIndex))
                    webcontent = String(webcontent.suffix(from: stopIndex))
                }
            }
            //Href
            if let hrefStartRange = webcontent.range(of: hrefStartWord){
                let startIndex = hrefStartRange.upperBound
                webcontent = String(webcontent.suffix(from: startIndex))
                if let hrefStopRange = webcontent.range(of: hrefStopWord){
                    let stopIndex = hrefStopRange.lowerBound
                    href = String(webcontent.prefix(upTo: stopIndex))
                    webcontent = String(webcontent.suffix(from: stopIndex))
                }
            }
            //Заголовок
            if let zagStartRange = webcontent.range(of: zagStartWord){
                let startIndex = zagStartRange.upperBound
                webcontent = String(webcontent.suffix(from: startIndex))
                if let zagStopRange = webcontent.range(of: zagStopWord){
                    let stopIndex = zagStopRange.lowerBound
                    zag = String(webcontent.prefix(upTo: stopIndex))
                    webcontent = String(webcontent.suffix(from: stopIndex))
                }
            }
            
            preview = preview ?? "null"
            href = href ?? "null"
            zag = zag ?? "null"
            preview = "https://www.nntu.ru" + preview!
            href = "https://www.nntu.ru" + href!
            news.append(article(preview: preview, zag: zag, href: href, text: text, hqimage: hqimage))
        }
        return news
    }


//MARK: - explicitlyGetHtmlFromHref()
// не используется, вместо неё используется safelyGetHtmlFromHref
func explicitlyGetHtmlFromHref (href: String?) -> String? {
    var webcontent: String?
    let a: String = href ?? ""
    let url = URL(string: a)!
    do {
        webcontent = try String(contentsOf: url)
    } catch {
        webcontent = """
        text-align: justify;"> Произошла ошибка в загрузке новости </p>
        """
        fatalError("Произошла ошибка в explicitlyGetHtmlFromHref")
    }
    return webcontent
}
//MARK: - findHQImage()
func findHQImage (html: String?) -> String?{
        //не очень понял, как это работает, но я решил попробовать это сделать с помощью img alt="" src="
        var output: String? = nil
        let startWord = """
img alt="" src="
"""
        let stopWord = """
" />
"""
        var webcontent = html ?? ""
        if let startWordRange = webcontent.range(of: startWord){
            let startIndex = startWordRange.upperBound
            webcontent = String(webcontent.suffix(from: startIndex))
            if let stopWordRange = webcontent.range(of: stopWord){
                let stopIndex = stopWordRange.lowerBound
                output = String(webcontent.prefix(upTo: stopIndex))
                output = "https://www.nntu.ru" + output!
            }
        }
        return output
}

//MARK: - findTheArticle()
func findTheArticle (html: String?) -> String?{
    var output: String? = nil
    var webcontent = html ?? ""
    let startWord = """
text-align: justify;">
"""
    let stopWord = """
</p>
"""
    while (webcontent.contains(startWord) == true){
        if let startRange = webcontent.range(of: startWord){
            let startIndex = startRange.upperBound
            webcontent = String(webcontent.suffix(from: startIndex))
            if let stopRange = webcontent.range (of: stopWord){
                let stopIndex = stopRange.lowerBound
                let stroke = String(webcontent.prefix(upTo: stopIndex))
                output = output ?? ""
                output = output! + stroke + "\n"
                webcontent = String(webcontent.suffix(from: stopIndex))
            }
        }
    }
    do{
        let doc = try SwiftSoup.parse(output ?? "")
        output = try doc.body()?.text()
    } catch {
        fatalError("SwiftSoup работает неправильно")
    }
    
    return output
}



//MARK: - safelyGetHtmlFromHref()
func safelyGetArticle (url: URL, completition: @escaping (String)->(Void)){
  var request = URLRequest(url: url)
  request.method = .get
  request.setValue("keep-alive", forHTTPHeaderField: "Connection")
  request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64)", forHTTPHeaderField: "User-Agent")

  URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
      print("не удалось загрузить новость")
      DispatchQueue.main.async {
        completition("")
      }
    return
    }

    let html = String(data: data, encoding: .utf8) ?? ""
    DispatchQueue.main.async {
      completition(findTheArticle(html: html) ?? "")
    }
  }.resume()
    
}



// MARK: - getMarks()
func getMarks (html: String) -> multipleSems {
    if (html == "") {return multipleSems()}
    if (html.contains("не найден")) {return multipleSems()}
    
    var webcontent = html
    let stopWord = """
</td>
"""
    let nameStartWord = """
td width="300px">
"""
    let disStopWord = """
</tr>
"""
    let FknStartWord = """
mark_1_k_n_exists">
"""
    let SknStartWord = """
mark_2_k_n_exists">
"""
    let PropStartWord = """
="text-center ">
"""
    let MarkStartWord = """
text-center mark_exists">
"""
    let TypeStartWord = """
="text-center">
"""
    
    var sems = [String]()
    var semNumbers = [Int]()
    var TheData = multipleSems()
    var tempSem = Sem()
    
    let semestr = " семестр"
    while (webcontent.contains(semestr) == true){
        if let semrange = webcontent.range(of: semestr){
            var numberSymbol = webcontent.index(semrange.lowerBound, offsetBy: -1)
            
            while (Int(webcontent[numberSymbol...numberSymbol]) != nil) {
                numberSymbol = webcontent.index(numberSymbol, offsetBy: -1)
            }
            numberSymbol = webcontent.index(numberSymbol, offsetBy: 1)
            
            let numberRange = numberSymbol..<semrange.lowerBound
            semNumbers.append(Int(webcontent[numberRange]) ?? 0)
            
            sems.append(String(webcontent[...semrange.upperBound]))
            webcontent = String(webcontent[semrange.upperBound...])
        }
    }
    sems.append(webcontent)
    sems.remove(at: 0)
    for i in 0..<sems.count {
        var semContent = sems[i]
        var prevSemContent = semContent
        while (prevSemContent.contains(nameStartWord)){
            var name = String()
            var type = String()
            var Fkn : String? = nil
            var Skn : String? = nil
            var PFkn : String? = nil
            var Pskn : String? = nil
            var Res : String? = nil
            semContent = prevSemContent
            
            //ищем начало дисциплины
            if let nameRange = semContent.range(of: nameStartWord){
                let startSymbol = nameRange.upperBound
                semContent = String(semContent.suffix(from: startSymbol))
                if let StopNameRange = semContent.range(of: stopWord){
                    let stopSymbol = StopNameRange.lowerBound
                    name = String(semContent.prefix(upTo: stopSymbol))
                    semContent = String(semContent.suffix(from: stopSymbol))
                }
            }
            
            //сохраняем все дисциплины, потому что дальше будем отделять одну от других
            prevSemContent = semContent
            
            //отделяем дисциплину
            if let StopWordRange = semContent.range(of: disStopWord){
                let stopSymbol = StopWordRange.upperBound
                semContent = String(semContent.prefix(upTo: stopSymbol))
            }
            
            //Первая и вторая кн, внутри них есть пропущенные часы. Вторая кн смотрится только при наличии первой
            if let FkRange = semContent.range(of: FknStartWord){
                let startSymbol = FkRange.upperBound
                semContent = String(semContent.suffix(from: startSymbol))
                //1 кн оценка
                if let StopFkRange = semContent.range (of: stopWord){
                    let stopSymbol = StopFkRange.lowerBound
                    Fkn = String(semContent.prefix(upTo: stopSymbol))
                    semContent = String(semContent.suffix(from: stopSymbol))
                }
                //1 кн пропущенные
                if let PropRange = semContent.range(of: PropStartWord){
                    let PropStartSymbol = PropRange.upperBound
                    semContent = String(semContent.suffix(from: PropStartSymbol))
                    if let StopPropRange = semContent.range(of: stopWord){
                        let stopSymbol = StopPropRange.lowerBound
                        PFkn = String(semContent.prefix(upTo: stopSymbol))
                        semContent = String(semContent.suffix(from: stopSymbol))
                    }
                }
                // смотрим 2 кн
                if let SkRange = semContent.range(of: SknStartWord){
                    let SkStartSymbol = SkRange.upperBound
                    semContent = String(semContent.suffix(from: SkStartSymbol))
                    if let StopSkRange = semContent.range(of: stopWord){
                        let stopSymbol = StopSkRange.lowerBound
                        Skn = String(semContent.prefix(upTo: stopSymbol))
                        semContent = String(semContent.suffix(from: stopSymbol))
                    }
                    //2 кн пропущенные
                    if let SkPropRange = semContent.range(of: PropStartWord){
                        let PropStartSymbol = SkPropRange.upperBound
                        semContent = String(semContent.suffix(from: PropStartSymbol))
                        if let StopPropRange = semContent.range(of: stopWord){
                            let stopSymbol = StopPropRange.lowerBound
                            Pskn = String(semContent.prefix(upTo: stopSymbol))
                            semContent = String(semContent.suffix(from: stopSymbol))
                        }
                    }
                }
            }
            if let ResRange = semContent.range(of: MarkStartWord){
                let startSymbol = ResRange.upperBound
                semContent = String(semContent.suffix(from: startSymbol))
                if let StopResRange = semContent.range(of: stopWord){
                    let stopSymbol = StopResRange.lowerBound
                    Res = String(semContent.prefix(upTo: stopSymbol))
                    semContent = String(semContent.suffix(from: stopSymbol))
                }
            }
            if let TypeRange = semContent.range(of: TypeStartWord){
                let startSymbol = TypeRange.upperBound
                semContent = String(semContent.suffix(from: startSymbol))
                if let StopTypeRange = semContent.range(of: stopWord){
                    let stopSymbol = StopTypeRange.lowerBound
                    type = String(semContent.prefix(upTo: stopSymbol))
                    semContent = String(semContent.suffix(from: stopSymbol))
                }
            }
            while (name.last == " "){
                name.remove(at: name.index(before: name.endIndex))
            }
            if (type == "з") {
                type = "зачёт"
            } else if (type == "зо"){
                type = "зачёт с оценкой"
            } else if (type == "эк"){
                type = "экзамен"
            } else if (type == "о"){
                type = "оценка"
            } else if (type == "кр"){
                type = "курсовая работа"
            }
            
            
            if (name != "Дисциплина"){
                tempSem.Semestr.append(Dis(Name: name, FirstKn: Fkn, PropFirstKn: PFkn, SecondKn: Skn, PropSecondKn: Pskn, ResType: type, Result: Res))
            }
        }
        tempSem.number = semNumbers[i]
        if !tempSem.isEmpty() {
            TheData.Sems.append(tempSem)
        }
        tempSem = Sem()
    }
    return TheData
}
//MARK: - tempData()
func tempData() -> multipleSems{
    var tempData = multipleSems()
    let dis1 = Dis(Name: "Иностранный язык", FirstKn: "50", PropFirstKn: "0", SecondKn: "50", PropSecondKn: "0", ResType: "зачёт", Result: "зачёт")
    let dis2 = Dis(Name: "Специальные главы математического анализа", FirstKn: "45", PropFirstKn: "0", SecondKn: "45", PropSecondKn: "0", ResType: "зачёт с оценкой", Result: "4")
    let dis3 = Dis(Name: "Пакеты прикладных программ", FirstKn: "40", PropFirstKn: "0", SecondKn: "50", PropSecondKn: "0", ResType: "экзамен", Result: "5")
    var tempSemestr = Sem(Semestr: [dis1,dis2,dis3])
    tempData.Sems.append(tempSemestr)
    tempSemestr = Sem(Semestr: [dis2,dis3, dis3])
    tempData.Sems.append(tempSemestr)
    tempSemestr = Sem(Semestr: [dis1,dis2])
    tempData.Sems.append(tempSemestr)
    return tempData
}

//MARK: - updateMarkInfo()
func updateMarkInfo(completion: @escaping (multipleSems, String) -> Void) {
  let data = UserDefaults.standard
  let lastName = data.string(forKey: "SecondName") ?? ""
  let firstName = data.string(forKey: "FirstName") ?? ""
  let otc = data.string(forKey: "Otchestvo") ?? ""
  let nZach = data.string(forKey: "Nstud") ?? ""
  let learnType = data.string(forKey: "UserType") ?? ""

  var request = URLRequest(url: marksURL)
  request.method = .post
  request.setValue("https://www.nntu.ru/content/studentam/uspevaemost", forHTTPHeaderField: "Referer")
  request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
  request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
  request.setValue("keep-alive", forHTTPHeaderField: "Connection")
  request.setValue("en-GB,en;q=0.9", forHTTPHeaderField: "Accept-Language")
  request.setValue("*/*", forHTTPHeaderField: "Accept")

  let httpBody = "last_name=\(lastName)&first_name=\(firstName)&otc=\(otc)&n_zach=\(nZach)&learn_type=\(learnType)"
  request.httpBody = httpBody.data(using: .utf8)
  URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
      DispatchQueue.main.async {
        completion(multipleSems(), "")
      }
      return
    }
    let html = String(data: data, encoding: .utf8) ?? ""
    DispatchQueue.main.async {
      completion(getMarks(html: html), html)
    }
  }.resume()
}

//MARK: - Colors
let NNTUblue = UIColor(red: 0/255, green: 114/255, blue: 188/255, alpha: 1)
let NNTUred = UIColor(red: 158/255, green: 40/255, blue: 14/255, alpha: 1)


//MARK: - GetNowWeek
func GetNowWeek () -> Int {
    
    var userCalendar = Calendar.current
    userCalendar.locale = Locale(identifier: "ru_UA")
    let weekOfYear = userCalendar.component(.weekOfYear, from: Date())
    
    return ((weekOfYear + 1) % 2)
}


//MARK: - TabBarConfigs
// это нужно для более понятного определения TabBar и его конфигураций в зависимости от пользователя
enum Tab: Int {
    case events = 0
    case marks = 1
    case timetable
    case tasks
    case more
}

enum TabBarConfig {
    case student
    case teacher
    case notAuthorized
}

extension TabBarConfig {
    var rawValue: [Int] {
        tabs.map { $0.rawValue }
    }
    
    var tabs: [Tab] {
        switch self {
        case .student:
            return [.events, .marks, .timetable, .tasks, .more]
        case .teacher:
            return [.events, .timetable, .more]
        case .notAuthorized:
            return [.events, .timetable, .more]
        }
    }
    
    static func from(entered: Bool, nstud: String?) -> TabBarConfig {
        guard entered else { return .notAuthorized }
        guard let nstud = nstud, !nstud.isEmpty else { return .teacher }
        return .student
    }
}

extension UITabBarController {
    func apply(_ config: TabBarConfig, vcs: [UIViewController]?){
        guard let vcs = vcs else { return }
        let indexes = config.rawValue
        let newTabs = indexes.map { vcs[$0] }
        viewControllers = newTabs
    }
}
