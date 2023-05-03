//
//  DBTTController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 23.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit
import WidgetKit


class DBTTController: UITableViewController, UIGestureRecognizerDelegate {
    
    func configureTabs(){
        entered = UserDefaults.standard.bool(forKey: "Entered")
        let nstud = UserDefaults.standard.string(forKey: "Nstud")
        tabBarVCs = self.tabBarController?.viewControllers
        let config = TabBarConfig.from(entered: entered, nstud: nstud)
        self.tabBarController?.apply(config, vcs: tabBarVCs)
    }
    
    private let calendarManager = CalendarManager()
    @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
    @IBOutlet var prevDayButton: UIButton!
    @IBOutlet var nextDayButton: UIButton!
    @IBOutlet var DayLabel: UILabel!
    
    @IBOutlet var ControlStack: UIStackView!
//    @IBOutlet var areAllActiveButton: UIBarButtonItem!
    
    
    
    var nowWeek = 0
    var weekAtTheMoment : Int {
        get {
            let moment = Date()
            var userCalendar = Calendar.current
            userCalendar.locale = Locale(identifier: "ru_UA")
            return userCalendar.component(.weekOfYear, from: moment) - startWeek + additionalWeek - 1
        }
    }
    var actualRow = -1
    var actualSection = -1
    
    var allLessons = [Lesson]()
    var arrangedTT = [[Lesson]]()
    let data = UserDefaults.standard
    var isBlue = false
    var areAllActive = false
    var isCalendarUpdating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        configureTabs()
        allLessons = CoreDataStack.shared.fetchLessons()
        if (checkAutoUpdate() == true || allLessons.count == 0){
            onlineTT()
        } else {
            self.refreshControl?.endRefreshing()
        }
        loadLabel()
        arrangedTT = getArrangedDataForWeek(tt: allLessons, week: nowWeek)
        getActualLesson()
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        //наводим красоту
        self.tableView.backgroundView = nil
        ControlStack.layer.cornerRadius = 10
        areAllActive = UserDefaults.standard.bool(forKey: "areAllActive")
//        areAllActiveButton.image = areAllActive ? UIImage(systemName: "tablecells.badge.ellipsis.fill") : UIImage(systemName: "tablecells.badge.ellipsis")
        
        //приколы с календарем
        isCalendarUpdating = data.bool(forKey: "CalendarTransfer")
        if (isCalendarUpdating && allLessons.count > 0){
            calendarManager.putTTinCalendar(tt: allLessons)
        }
        
        self.tableView.reloadData()
        self.tableView.backgroundColor = UIColor.systemBackground
        
        
        //делаем свайпы ура (наконец-то)
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeNext(_:)))
        nextSwipe.direction = .left
        self.tableView.addGestureRecognizer(nextSwipe)
        
        let prevSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipePrev(_:)))
        prevSwipe.direction = .right
        self.tableView.addGestureRecognizer(prevSwipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        areAllActive = UserDefaults.standard.bool(forKey: "areAllActive")
        self.tableView.reloadData()
        updateBadge(self)
    }
    
    
    @objc func refresh(){
        allLessons = CoreDataStack.shared.fetchLessons()
        if (checkAutoUpdate() == true || allLessons.count == 0){
            onlineTT()
        } else {
            self.refreshControl?.endRefreshing()
        }
        updatePlate()
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        tableView.reloadData()
        
        //приколы с календарем
        isCalendarUpdating = data.bool(forKey: "CalendarTransfer")
        if (isCalendarUpdating && allLessons.count > 0){
            calendarManager.putTTinCalendar(tt: allLessons)
        }
    }
    
    
    
    func datePicked(){
        if (dateForTT == nil) {return}
        var userCalendar = Calendar.current
        userCalendar.locale = Locale(identifier: "ru_UA")
        var newNowWeek = userCalendar.component(.weekOfYear, from: dateForTT!) - startWeek + additionalWeek
        newNowWeek -= 1
        nowWeek = newNowWeek
        if (nowWeek == weekAtTheMoment){
            getActualLesson()
        } else {
            actualSection = -1
            actualRow = -1
        }
        updatePlate()
        self.tableView.reloadData()
        dateForTT = nil
    }
    
    
    func getActualLesson(){
        actualRow = -1
        actualSection = -1
        let now = Date()
        var userCalendar = Calendar.current
        userCalendar.locale = Locale(identifier: "ru_UA")
        actualSection = userCalendar.component(.weekday, from: now)
        let hour = userCalendar.component(.hour, from: now)
        let minute = userCalendar.component(.minute, from: now)
        let estTime = hour*100 + minute
        if (actualSection == 1){
            actualSection = 7
        } else {actualSection -= 1}
        actualSection -= 1
        var nextDay = false
        if (arrangedTT.count > 0){
            var found = false
            for i in (0 ... arrangedTT.count - 1){
                if (arrangedTT[i].count > 0){
                    if (arrangedTT[i][0].day == actualSection){
                        actualSection = i
                        found = true
                        break
                    } else if (arrangedTT[i][0].day > actualSection){
                        found = true
                        actualSection = i
                        nextDay = true
                        break
                    }
                }
            }
            if (!found){
                //если ничего не нашлось и он не брейкнулся, зайдет сюда
                actualRow = -1
                actualSection = -1
                return
            }
        } else {
            actualRow = -1
            actualSection = -1
            return
        }
        
        if (nextDay) {
            actualRow = 0
            return
        }
        
        for i in (0 ... arrangedTT[actualSection].count - 1){
            if (timeFromString(string: arrangedTT[actualSection][i].stopTime) > estTime){
                actualRow = i
                break
            }
        }
        if (actualRow == -1 && actualSection < arrangedTT.count - 1){
            actualSection += 1
            if (arrangedTT[actualSection].count > 0){
                actualRow = 0
            } else {
                actualRow = -1
                actualSection = -1
            }
        }
    }
    
    

    func filterByDay(all: [Lesson], day: Int, week: Int) -> [Lesson]{
//        print ("Неделя:\(week)  День:\(day)")
        var output = [Lesson]()
        if (all.count == 0){return output}
        for i in (0 ... all.count - 1){
            if (all[i].day == day){
                if (all[i].weeks.contains(-2) && week % 2 == 0){
                    output.append(all[i])
                }
                else if (all[i].weeks.contains(-1) && week % 2 == 1){
                    output.append(all[i])
                }
                else if (all[i].weeks.contains(week)){
                    output.append(all[i])
                }
            }
        }
        return sortByTime(output)
    }
    
    
    func getArrangedDataForWeek(tt: [Lesson], week: Int) -> [[Lesson]]{
        var output = [[Lesson]]()
        for i in (0 ... 6){
            let dayData = filterByDay(all: tt, day: i, week: week)
            if (dayData.count > 0) {
                output.append(dayData)
            }
        }
        return output
    }
    
    func onlineTT(){
        downloadTT(data.string(forKey: "Group") ?? "", callback: { lessons in
            self.refreshControl?.endRefreshing()
            if (lessons.count == 0 && self.allLessons.count == 0){
                let popup = UIAlertController(title: "Расписание не найдено", message: "Вы можете добавить его в редакторе расписания (в настройках)", preferredStyle: .alert)
                let kaction = UIAlertAction(title: "ОК", style: .default)
                popup.addAction(kaction)
                self.present(popup, animated: true)
                self.tableView.reloadData()
            } else {
                self.allLessons = lessons
                CoreDataStack.shared.saveManyLessons(objects: lessons)
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                self.arrangedTT = self.getArrangedDataForWeek(tt: self.allLessons, week: self.nowWeek)
                self.tableView.reloadData()
            }
        })
    }
    
    func checkAutoUpdate() -> Bool{
        let state = data.integer(forKey: "autoUpdate")
        if (state == 1){
            return true
        } else { return false }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return arrangedTT.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrangedTT[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (arrangedTT[section].count == 0){
            return DaysOfWeek[section]
        } else {
            return DaysOfWeek[arrangedTT[section][0].day]
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath.row == actualRow && indexPath.section == actualSection) || areAllActive){
            let cell = tableView.dequeueReusableCell(withIdentifier: "active", for: indexPath) as! activeTVCell
            cell.data = arrangedTT[indexPath.section][indexPath.row]
            cell.fillIn(isBlue)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passiveLesson", for: indexPath) as! passiveTVCell
            cell.data = arrangedTT[indexPath.section][indexPath.row]
            cell.fillIn(isBlue)
            return cell
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("Hello")
    }
    
    
    
    @IBAction func prevWeek(_ sender: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        nowWeek -= 1
        updatePlate()
    }
    
    @IBAction func nextWeek(_ sender: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        nowWeek += 1
        updatePlate()
    }
    
    @objc func swipeNext(_ sender: UIGestureRecognizer){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        nowWeek += 1
        updatePlate()
    }
    
    @objc func swipePrev(_ sender: UIGestureRecognizer){
        if (nowWeek > 0){
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            nowWeek -= 1
            updatePlate()
        }
    }
    
    func setWeekText(_ week: Int){
        var attributes = [NSAttributedString.Key : Any]()
        if week == weekAtTheMoment {
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 17, weight: .semibold)
            let color: UIColor = week % 2 == 0 ? .blue : .red
            attributes[NSAttributedString.Key.foregroundColor] = color
            setButtonsColor(color)
        } else {
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 17, weight: .regular)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.label
            setButtonsColor(UIColor.link)
        }
        
        DayLabel.attributedText = NSMutableAttributedString.init(string: "\(week) неделя", attributes: attributes)
    }
    
    func setButtonsColor(_ color: UIColor){
        prevDayButton.tintColor = color
        nextDayButton.tintColor = color
    }
    
    
    func updatePlate(){
        if (nowWeek == 0){
            prevDayButton.isEnabled = false
        } else {
            prevDayButton.isEnabled = true
        }
        
        arrangedTT = getArrangedDataForWeek(tt: allLessons, week: nowWeek)
        
        isBlue = nowWeek % 2 == 0
        
        if nowWeek == weekAtTheMoment {
            getActualLesson()
        } else {
            actualSection = -1
            actualRow = -1
        }
        
        setWeekText(nowWeek)
        
        tableView.reloadData()
    }
    
    func loadLabel(){
        nowWeek = weekAtTheMoment
        setWeekText(nowWeek)
        isBlue = nowWeek % 2 == 0
        getActualLesson()
    }
    
    // MARK: - Navigation
    @IBAction func goPickTime(_ sender: Any) {
        performSegue(withIdentifier: "goPickTime", sender: (Any).self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPassiveLesson"){
            let detailVC = segue.destination as! singleLessonViewController
            let newCell = sender as! passiveTVCell
            detailVC.lesson = newCell.data
        } else if (segue.identifier == "showActiveLesson"){
            let detailVC = segue.destination as! singleLessonViewController
            let newCell = sender as! activeTVCell
            detailVC.lesson = newCell.data
        } else if (segue.identifier == "goPickTime"){
            dateForTT = nil
            freeDBTTController = self
        }
    }
    

}
