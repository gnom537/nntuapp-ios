//
//  DBEditorViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 21.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit
import WidgetKit

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}


class DBEditorViewController: UITableViewController {
    
//    MARK: vars
    @IBOutlet var daySegment: UISegmentedControl!
    @IBOutlet var saveButton: UIButton!

    var showedLessons = [Lesson]()
    
    //    MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton?.layer.cornerRadius = 5
        editingTT = CoreDataStack.shared.fetchLessons()
        if (checkAutoUpdate() == true && editingTT.count == 0){
            onlineTT()
        }
        showedLessons = filterLessons(array: editingTT, day: daySegment.selectedSegmentIndex)
        
        // свайпы от 1 апреля
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextDay))
        nextSwipe.direction = .left
        self.tableView.addGestureRecognizer(nextSwipe)
        
        let prevSwipe = UISwipeGestureRecognizer(target: self, action: #selector(prevDay))
        prevSwipe.direction = .right
        self.tableView.addGestureRecognizer(prevSwipe)
    }
    
    
//    MARK: viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (freeLesson != nil){
            if (editingIndex != nil){
                editingTT[editingIndex!] = freeLesson!
            } else {
                editingTT.append(freeLesson!)
            }
            saveTT()
            freeLesson = nil
            editingIndex = nil
            
            showedLessons = filterLessons(array: editingTT, day: daySegment.selectedSegmentIndex)
            self.tableView.reloadData()
        }
    }
    
    //MARK: onlineTT()
    func onlineTT(){
        downloadTT(UserDefaults.standard.string(forKey: "Group") ?? "", callback: { lessons in
            if (lessons.count == 0 && editingTT.count == 0){
                print("Расписания нет")
            } else {
                editingTT = lessons
                CoreDataStack.shared.saveManyLessons(objects: lessons)
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                self.showedLessons = self.filterLessons(array: editingTT, day: self.daySegment.selectedSegmentIndex)
                self.tableView.reloadData()
            }
        })
    }
    
    //    MARK: checkAutoUpdate()
    func checkAutoUpdate() -> Bool{
        let state = UserDefaults.standard.integer(forKey: "autoUpdate")
        if (state == 1){
            return true
        } else { return false }
    }

    
    
    
    //    MARK: filterLessons()
    func filterLessons(array: [Lesson], day: Int) -> [Lesson]{
        var output = [Lesson]()
        if (array.count == 0){return output}
        for i in (0 ... array.count - 1){
            if (array[i].day == day){
                output.append(array[i])
            }
        }
        output = output.sorted(by: {timeFromString(string: $0.startTime) < timeFromString(string: $1.startTime)})
        return output
    }
    
    //    MARK: findIndexOfLesson()
    func findIndexOfLesson(lesson: Lesson) -> Int{
        for i in (0 ... editingTT.count - 1){
            let ltcmp = editingTT[i]
            var same = true
            if (same){
                same = same && (ltcmp.name == lesson.name)
            }
            if (same){
                same = same && (ltcmp.startTime == lesson.startTime)
            }
            if (same){
                same = same && (ltcmp.stopTime == lesson.stopTime)
            }
            if (same){
                same = same && (ltcmp.day == lesson.day)
            }
            if (same){
                same = same && (ltcmp.weeks == lesson.weeks)
            }
            if (same){
                same = same && (ltcmp.rooms == lesson.rooms)
            }
            if (same){
                same = same && (ltcmp.type == lesson.type)
            }
            if (same){
                same = same && (ltcmp.teacher == lesson.teacher)
            }
            if (same){
                same = same && (ltcmp.notes == lesson.notes)
            }
            if (same){
                return i
            }
        }
        return 0
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return showedLessons.count
    }

    //    MARK: filling cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DBLessonCell", for: indexPath) as! DBLessonCell
        cell.data = showedLessons[indexPath.row]
        cell.nameLabel.text = cell.data.name
        cell.startTimeLabel.text = cell.data.startTime
        cell.stopTimeLabel.text = cell.data.stopTime
        var tempString = ""
        if (cell.data.rooms.count != 0){
            for i in (0 ... cell.data.rooms.count - 1){
                tempString += cell.data.rooms[i] + ", "
            }
        }
        if (cell.data.rooms.count != 0){
            tempString = String(tempString.dropLast(2))
        }
        if (cell.data.teacher != ""){
            if (cell.data.rooms.count != 0){
                tempString += ", "
            }
            tempString += cell.data.teacher
        }
        cell.lowerInfoLabel.text = tempString.uppercased()
        
        tempString = ""
        let even = cell.data.weeks.contains(-2)
        let odd = cell.data.weeks.contains(-1)
        var other = false
        for i in (0 ... cell.data.weeks.count - 1){
            if (cell.data.weeks[i] > 0){
                other = true
                break
            }
        }
        
        if (even && !odd){
            tempString += "ЧН"
        } else if (odd && !even){
            tempString += "НЧ"
        } else if (even && odd){
            tempString += "ЧН + НЧ"
        }
        if (other){
            if (even || odd){
                tempString += " + "
            }
            for i in (0 ... cell.data.weeks.count - 1){
                if (cell.data.weeks[i] > 0){
                    tempString += String(cell.data.weeks[i]) + ", "
                }
            }
            tempString = String(tempString.dropLast(2))
        }
        
        if (cell.data.type != ""){
            tempString += ", " + cell.data.type
        }
        if (cell.data.notes != ""){
            tempString += ", " + cell.data.notes
        }
//        cell.upperInfoLabel.text = tempString.uppercased()
        let colorfulS = NSMutableAttributedString(string: tempString.uppercased())
        colorfulS.setColorForText(textForAttribute: "НЧ", withColor: NNTUred)
        colorfulS.setColorForText(textForAttribute: "ЧН", withColor: NNTUblue)
        cell.upperInfoLabel.attributedText = colorfulS
        
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    //    MARK: Deleting
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let lessonToDelete = showedLessons[indexPath.row]
            let indexToDelete = findIndexOfLesson(lesson: lessonToDelete)
            editingTT.remove(at: indexToDelete)
            showedLessons = filterLessons(array: editingTT, day: daySegment.selectedSegmentIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTT()
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //    MARK: ChangeDay()
    @IBAction func daySelected(_ sender: UISegmentedControl) {
        showedLessons = filterLessons(array: editingTT, day: daySegment.selectedSegmentIndex)
        self.tableView.reloadData()
    }
    
    @objc func prevDay(){
        if (daySegment.selectedSegmentIndex > 0){
            daySegment.selectedSegmentIndex -= 1
            showedLessons = filterLessons(array: editingTT, day: daySegment.selectedSegmentIndex)
            self.tableView.reloadData()
        }
    }
    
    @objc func nextDay(){
        if (daySegment.selectedSegmentIndex < daySegment.numberOfSegments - 1){
            daySegment.selectedSegmentIndex += 1
            showedLessons = filterLessons(array: editingTT, day: daySegment.selectedSegmentIndex)
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    MARK: prepare()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let goToVC = segue.destination as! EditorSingleParaViewController
        if (segue.identifier == "EditLessonToTT"){
            viewDidAppear(false)
            let cell = sender as! DBLessonCell
            editingIndex = findIndexOfLesson(lesson: cell.data)
            goToVC.cellData = cell
        }
        goToVC.day = daySegment.selectedSegmentIndex
        TTeditorVC = self
    }
    
    //    MARK: addNewOne()
    @IBAction func addNewOne(_ sender: Any) {
        performSegue(withIdentifier: "AddLessonToTT", sender: (Any).self)
    }
    
    //    MARK: popupSaved()
    func popupSaved() {
        let popup = UIAlertController(title: "Автозагрузка теперь выключена 👌", message: "Чтобы измененное расписание не заменилось загруженным с интернета, автозагрузка отключена. Ваши изменения в расписании сохраняются на устройстве автоматически, также вы можете загрузить ваше расписание на сервер", preferredStyle: .alert)
        let kaction = UIAlertAction(title: "ОК", style: .default)
        popup.addAction(kaction)
        present(popup, animated: true)
        return
    }
    
    //MARK: saveTT()
    func saveTT(){
        UserDefaults.standard.setValue(-1, forKey: "autoUpdate")
        if (AUSwitch?.isOn == true){
            popupSaved()
            successFeedback()
        }
        AUSwitch?.isOn = false
        CoreDataStack.shared.saveManyLessons(objects: editingTT)
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }

    }
    
    
    
    //    MARK: saveLessonArrayToCD()
    @IBAction func saveLessonArrayToCD(_ sender: UIButton) {
        UserDefaults.standard.setValue(-1, forKey: "autoUpdate")
        AUSwitch?.isOn = false
        CoreDataStack.shared.saveManyLessons(objects: editingTT)
        successFeedback()
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }

        popupSaved()
    }
    
    
}
