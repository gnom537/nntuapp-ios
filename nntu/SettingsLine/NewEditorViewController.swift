//
//  NewEditorViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 27.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class NewEditorViewController: UIViewController, UITextFieldDelegate {
    
    var ControllerData : TimeTable = TimeTable()
    var tempDay = Day()
    var posDay : Int = 0
    var posWeek : Int = 0 // 0 - чет, 1 - нечет
    
    var keyboardHeight: CGFloat = 0
    
    
    @IBOutlet var StackYPosition: NSLayoutConstraint!
    @IBOutlet var SaveButton: UIButton!
    
    
    
    @IBOutlet var StartTimes: [UITextField]!
    @IBOutlet var StopTimes: [UITextField]!
    @IBOutlet var Names: [UITextField]!
    @IBOutlet var Rooms: [UITextField]!
    
    
    @IBOutlet var WeekType: UISegmentedControl!
    @IBOutlet var NowDay: UILabel!
    
    @IBOutlet var BackButton : UIButton!
    @IBOutlet var ForwardButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo()
        
        for i in 0...5 {
            StartTimes[i].delegate = self
            StopTimes[i].delegate = self
            Names[i].delegate = self
            Rooms[i].delegate = self
        }
        
        SaveButton.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    //MARK: - updateInfo
    func updateInfo () {
        //настройка выбора дня
        BackButton.isEnabled = true
        ForwardButton.isEnabled = true
        NowDay.text = DaysOfWeek[posDay]
        
        //настройка кнопок
        if (posDay == 0) {
            BackButton.isEnabled = false
        } else if (posDay == 5) {
            ForwardButton.isEnabled = false
        }
        
        if (ControllerData.TimeTable[posWeek] == nil){
            ControllerData.TimeTable[posWeek] = Week()
        }
        
        if (ControllerData.TimeTable[posWeek]?.Days[posDay] == nil){
            ControllerData.TimeTable[posWeek]?.Days[posDay] = Day()
        }
        
        for i in 0...5 {
            if (ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[i] == nil){
                ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[i] = DisTime()
            }
            StartTimes[i].text = ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[i]?.StartTime ?? ""
            StopTimes[i].text = ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[i]?.StopTime ?? ""
            Names[i].text = ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[i]?.Name ?? ""
            Rooms[i].text = ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[i]?.Aud ?? ""
            
            CleanFromNulls(input: StartTimes[i])
            CleanFromNulls(input: StopTimes[i])
            CleanFromNulls(input: Names[i])
            CleanFromNulls(input: Rooms[i])
        }
    }
    
    //MARK: - TextField Actions
    @IBAction func StartTimeChanged(_ sender: UITextField) {
        let index = getIndex(input: sender)
        ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.StartTime = sender.text
    }
    
    
    //MARK: stopTime
    @IBAction func StopTimeChanged(_ sender: UITextField) {
        let index = getIndex(input: sender)
        ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.StopTime = sender.text
    }
    
    //MARK: name
    @IBAction func NameChanged(_ sender: UITextField) {
        let index = getIndex(input: sender)
        ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.Name = sender.text
    }

    //MARK: room
    @IBAction func RoomChanged(_ sender: UITextField) {
        let index = getIndex(input: sender)
        if (ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.Aud == nil){
            ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.Aud = String()
        }
        if sender.text?.first == "6" {
            StartTimes[index].text = SStartTimes[index]
            StopTimes[index].text = SStopTimes[index]
        } else if (sender.text?.first == "5" || sender.text?.first == "4" || sender.text?.first == "3" || sender.text?.first == "2" || sender.text?.first == "1") {
            StartTimes[index].text = MainStartTimes[index]
            StopTimes[index].text = MainStopTimes[index]
        }
        ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.StartTime = StartTimes[index].text
        ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.StopTime = StopTimes[index].text
        ControllerData.TimeTable[posWeek]?.Days[posDay]?.Paras[index]?.Aud = sender.text
    }

    
    func doAHapticFeedback(){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    
    //MARK: - Buttons and Segment
    @IBAction func WeekChanged(_ sender: UISegmentedControl) {
        StopEditing()
        posWeek = sender.selectedSegmentIndex
        updateInfo()
        doAHapticFeedback()
    }
    
    @IBAction func MoveToFuture(_ sender: Any) {
        StopEditing()
        posDay += 1
        updateInfo()
        doAHapticFeedback()
    }
    
    @IBAction func MoveToPast(_ sender: Any) {
        StopEditing()
        posDay -= 1
        updateInfo()
        doAHapticFeedback()
    }
    
    //MARK: - getIndex
    func getIndex (input: UITextField) -> Int {
        for i in 0...5 {
            if StartTimes[i] == input {
                return i
            } else if StopTimes[i] == input {
                return i
            } else if Names[i] == input {
                return i
            } else if Rooms[i] == input {
                return i
            }
        }
        return 0
    }
    
    
    @IBAction func TapHappened(_ sender: Any) {
        StopEditing()
    }
    
    
    
    
    //MARK: - SAVE EVERYTHING
    @IBAction func SaveEverything(_ sender: UIButton) {
        deleteAllData("CoreDisTime")
        saveTimeTable(input: ControllerData)
        sender.titleLabel?.text = NSLocalizedString("Сохранено", comment: "")
        print (stringFromTimeTable(input: ControllerData))
        POSTtoServer(input: stringFromTimeTable(input: ControllerData))
    }
    
    
    //MARK: - keyboard stuff
    func StopEditing() {
        for i in 0...5 {
            StartTimes[i].endEditing(true)
            StopTimes[i].endEditing(true)
            Names[i].endEditing(true)
            Rooms[i].endEditing(true)
            UIView.animate(withDuration: 0.25, animations: ({
                self.StackYPosition.constant = 10
                self.view.layoutIfNeeded()
            }))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        StopEditing()
        return false
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    
    @IBAction func CheckForMovingKeyboard(_ sender: UITextField) {
        //let height = Names[5].layer.position.y
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight - (Names[5].superview?.convert(Names[5].frame.origin, to: nil).y)! - 5
        print(Int(height))
        print(Int(keyboardHeight))
        //print(Int(onemorePosition))
        if height < keyboardHeight && self.StackYPosition.constant == 10 {
            let difference = keyboardHeight - height + 55
            UIView.animate(withDuration: 0.25, animations: ({
                self.StackYPosition.constant -= difference
                self.view.layoutIfNeeded()
            }))
        }
    }
    
    
    //MARK: - moreActions()
    @IBAction func moreActions(_ sender: Any) {
        let popup = UIAlertController(title: NSLocalizedString("Дополнительные действия", comment: ""), message: nil , preferredStyle: .actionSheet)
        let clearDayAction = UIAlertAction(title: NSLocalizedString("Очистить день", comment: ""), style: .default){
            [unowned self] action in
            self.clearDay()
        }
        let clearAllAction = UIAlertAction(title: NSLocalizedString("Очистить неделю", comment: ""), style: .default){
            [unowned self] action in
            self.clearAll()
        }
        let copyAction = UIAlertAction(title: NSLocalizedString("Перенести день с другой недели", comment: ""), style: .default){
            [unowned self] action in
            self.copyFromAnotherWeek()
        }
        let fetchAction = UIAlertAction(title: NSLocalizedString("Показать существующее расписание", comment: ""), style: .default) {
            [unowned self] action in
            self.loadExistingOne()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel)
        
        popup.addAction(clearDayAction)
        popup.addAction(clearAllAction)
        popup.addAction(copyAction)
        popup.addAction(fetchAction)
        popup.addAction(cancelAction)
        
        present(popup, animated: true)
    }
    
    func clearDay() {
        ControllerData.TimeTable[posWeek]?.Days[posDay] = Day()
        updateInfo()
    }
    
    func clearAll() {
        clearDay()
        ControllerData = TimeTable()
        posDay = 0
        posWeek = 0
        updateInfo()
    }
    
    func copyFromAnotherWeek() {
        var anotherWeek = 0
        if posWeek == 0 {anotherWeek = 1}
        let anotherDay = ControllerData.TimeTable[anotherWeek]?.Days[posDay]
        ControllerData.TimeTable[posWeek]?.Days[posDay] = anotherDay
        updateInfo()
    }
    
    func loadExistingOne() {
        ControllerData = fetchTimeTable() ?? TimeTable()
        updateInfo()
    }
    
    func CleanFromNulls(input: UITextField) {
        if input.text == "null" {input.text = ""}
    }
    
    
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
