//
//  TimeTableViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 28.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class TimeTableViewController: UITableViewController {
    
    @objc func refresh(){
        GETfromServer(comletition: ({ loaded in
            let tempData = scrapeTimeTable(input: loaded)
            if tempData.count != 0 {
                let lessons = disTimeToTimeTable(lessons: tempData)
                self.controllerData = lessons
                deleteAllData("CoreDisTime")
                saveTimeTable(input: lessons)
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }))
        let now = Date()
        let userCalendar = Calendar.current
        TopLabel.text = "Сегодня \(userCalendar.component(.day, from: now)) \(Months[userCalendar.component(.month, from: now)-1]), \(ShortDaysOfWeek[userCalendar.component(.weekday, from: now)-1])"
    }
    
    var weekColor = NNTUblue
    var nowWeek : Int = 0
    var controllerData : TimeTable = TimeTable()
    @IBOutlet var WeekSegment: UISegmentedControl!
    @IBOutlet var TopLabel: UILabel!
    
    let NNTUcolors : [UIColor] = [NNTUblue, NNTUred]
    var chosenRoom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerData = fetchTimeTable()!
        GETfromServer(comletition: ({ loaded in
            let tempData = scrapeTimeTable(input: loaded)
            if tempData.count != 0 {
                let lessons = disTimeToTimeTable(lessons: tempData)
                self.controllerData = lessons
                deleteAllData("CoreDisTime")
                saveTimeTable(input: lessons)
                self.tableView.reloadData()
            }
        }))
        //print (coreDiss)
        //print (fetchParas())
        
        //определяем неделю
        nowWeek = GetNowWeek()
        WeekSegment.selectedSegmentIndex = nowWeek
        checkColor()
        
        //заполняем надпись
        let now = Date()
        let userCalendar = Calendar.current
        TopLabel.text = "Сегодня \(userCalendar.component(.day, from: now)) \(Months[userCalendar.component(.month, from: now)-1]), \(ShortDaysOfWeek[userCalendar.component(.weekday, from: now)-1])"
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //controllerData = fetchTimeTable() ?? TimeTable()
        nowWeek = GetNowWeek()
        WeekSegment.selectedSegmentIndex = nowWeek
        checkColor()
        UIView.animate(withDuration: 0.25, animations: ({
            self.controllerData = fetchTimeTable()!
            GETfromServer(comletition: ({ loaded in
                let tempData = scrapeTimeTable(input: loaded)
                if tempData.count != 0 {
                    let lessons = disTimeToTimeTable(lessons: tempData)
                    self.controllerData = lessons
                    deleteAllData("CoreDisTime")
                    saveTimeTable(input: lessons)
                }
                
                self.tableView.reloadData()
            }))
        }))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableDayCell", for: indexPath) as! TimeTableDayCell
        cell.neededColor = weekColor
        cell.DayName.text = DaysOfWeek[indexPath.row]
        cell.updateColor()
        
        for i in 0...5 {
            let lesson = controllerData.TimeTable[nowWeek]?.Days[indexPath.row]?.Paras[i]
            let room = lesson?.Aud
            cell.ButtonViews[i].isHidden = false
            
            
            if (lesson?.Name == "" || lesson?.Name == "null" || lesson?.Name == nil){
                cell.StartTimes[i].isHidden = true
                cell.StopTimes[i].isHidden = true
                cell.ButtonViews[i].isHidden = true
                cell.ButtonViews[i].alpha = 0
                cell.Names[i].text = "\(i+1) \(NSLocalizedString("пары нет", comment: ""))"
                cell.Names[i].alpha = 0.3
            } else {
                cell.ButtonViews[i].alpha = 1
                cell.StartTimes[i].isHidden = false
                cell.StopTimes[i].isHidden = false
                cell.Names[i].alpha = 1
                cell.Names[i].textAlignment = .left
                cell.StartTimes[i].text = lesson?.StartTime
                cell.StopTimes[i].text = lesson?.StopTime
                cell.Names[i].text = lesson?.Name
                cell.ButtonLabels[i].text = room
            }
            
            if (cell.ButtonLabels[i].text == nil || cell.ButtonLabels[i].text == ""){
                cell.ButtonViews[i].isHidden = true
                cell.ButtonViews[i].alpha = 0
            }
            
        }
        
        //cell.TimeTableData = controllerData.TimeTable[nowWeek]?.Days[indexPath.row] ?? Day()
        // Configure the cell...

        return cell
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    
    func checkColor() {
        weekColor = NNTUcolors[nowWeek]
        self.tableView.reloadData()
        //self.tabBarController?.view.tintColor = NNTUcolors[nowWeek]
    }
    
    func getCellfromButton (input: UIButton) -> TimeTableDayCell {
        let output = input.superview?.superview?.superview?.superview?.superview?.superview as! TimeTableDayCell
        return output
    }
    
    func getButtonIndexInCell (button: UIButton, cell: TimeTableDayCell) -> Int {
        for i in 0...5 {
            if button.superview == cell.ButtonViews[i]{
                return i
            }
        }
        print ("Индекс кнопки в ячейке не найден")
        return 0
    }
    
    
    //MARK: - ButtonTapped()
    @IBAction func ButtonTapped(_ sender: UIButton) {
        print ("Кнопка нажата")
        let superviewCell = getCellfromButton(input: sender)
        let index = getButtonIndexInCell(button: sender, cell: superviewCell)
        chosenRoom = superviewCell.ButtonLabels[index].text ?? ""
        performSegue(withIdentifier: "ShowRoom", sender: (UIButton).self)
    }
    
    //MARK: - ChangeTheWeek()
    @IBAction func ChangeTheWeek(_ sender: UISegmentedControl) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        if nowWeek == 1 {
            nowWeek = 0
        } else {nowWeek = 1}
        checkColor()
    }
    
    
    //MARK: - prepare()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let goToVC = segue.destination as! NavigationViewController
        goToVC.preloadedRoom = chosenRoom
    }
    
    
    
    
    
}
