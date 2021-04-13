//
//  SingleParaViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 21.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class EditorSingleParaViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: vars
    @IBOutlet var TypeButtons: [UIView]!
    @IBOutlet var TimeButtons: [UIView]!
    @IBOutlet var WeekButtons: [UIView]!
    
    //кнопки внутри для поиска
    @IBOutlet var innerButtons: [UIButton]!
    @IBOutlet var innerTypeButtons: [UIButton]!
    @IBOutlet var innerWeekButtons: [UIButton]!
    
    @IBOutlet var startTimes : [UILabel]!
    @IBOutlet var stopTimes: [UILabel]!
    
    @IBOutlet var NameField: UITextField!
    @IBOutlet var roomField: UITextField!
    @IBOutlet var teacherField: UITextField!
    @IBOutlet var noteField: UITextField!
    
    @IBOutlet var customStartTime: UITextField!
    @IBOutlet var customStopTime: UITextField!
    @IBOutlet var customWeeks: UITextField!
    @IBOutlet var customType: UITextField!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var bottomContentConstraint: NSLayoutConstraint!
    
    var tempLesson = emptyLesson()
    
    var cellData: DBLessonCell?
    var day: Int?
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        let radius: CGFloat = 7
        for i in (0 ... TypeButtons.count - 1) {
            TypeButtons[i].layer.cornerRadius = radius
        }
        for i in (0 ... TimeButtons.count - 1) {
            TimeButtons[i].layer.cornerRadius = radius
        }
        for i in (0 ... WeekButtons.count - 1) {
            WeekButtons[i].layer.cornerRadius = radius
        }
        
        NameField.delegate = self
        roomField.delegate = self
        teacherField.delegate = self
        noteField.delegate = self
        
        customType.delegate = self
        customStartTime.delegate = self
        customStopTime.delegate = self
        customWeeks.delegate = self
        
        tempLesson.day = day ?? 0
        if (cellData != nil){
            tempLesson = cellData!.data
            fillIn(data: tempLesson)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    //MARK: - objc thing
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstraint.constant = keyboardHeight
            bottomContentConstraint.constant = keyboardHeight
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case NameField:
            roomField.becomeFirstResponder()
        case roomField:
            teacherField.becomeFirstResponder()
        case teacherField:
            noteField.becomeFirstResponder()
        case noteField:
            noteField.resignFirstResponder()
        case customType:
            roomField.becomeFirstResponder()
        case customStartTime:
            customStopTime.becomeFirstResponder()
        case customStopTime:
            teacherField.becomeFirstResponder()
        case customWeeks:
            teacherField.becomeFirstResponder()
        default:
            print("Какое-то из полей я забыл")
        }
        return false
    }
    
    
    //MARK: - fillIn()
    func fillIn (data: Lesson){
        //easy stuff
        NameField.text = data.name
        teacherField.text = data.teacher
        noteField.text = data.notes
        
        //MARK: weeks
        if (data.weeks.contains(-2)){
            colorizeButton(button: innerWeekButtons[0], active: true)
        }
        if (data.weeks.contains(-1)){
            colorizeButton(button: innerWeekButtons[1], active: true)
        }
        var tempString = ""
        if (data.weeks.count > 0){
            for i in (0 ... data.weeks.count - 1){
                if (data.weeks[i] != -1 && data.weeks[i] != -2){
                    tempString += String(data.weeks[i]) + ", "
                }
            }
            if (tempString != ""){
                colorizeView(view: WeekButtons[WeekButtons.count - 1], active: true)
                customWeeks.text = String(tempString.dropLast(2))
            }
        }
        
        
        //MARK: rooms
        tempString = ""
        if (data.rooms.count > 0){
            for i in (0 ... data.rooms.count - 1){
                tempString += String(data.rooms[i]) + ", "
            }
            if (tempString != ""){
                roomField.text = String(tempString.dropLast(2))
            }
        }
        
        //MARK: type
        if (data.type == "Лекция"){
            colorizeButton(button: innerTypeButtons[0], active: true)
        } else if (data.type == "Практика"){
            colorizeButton(button: innerTypeButtons[1], active: true)
        } else if (data.type == "Лаб.работа"){
            colorizeButton(button: innerTypeButtons[2], active: true)
        } else if (data.type != ""){
            colorizeView(view: TypeButtons[TypeButtons.count - 1], active: true)
            customType.text = data.type
        }
        
        //MARK: time
        var found = false
        for i in (0 ... SStartTimes.count - 2){
            if (SStartTimes[i] == data.startTime && SStopTimes[i] == data.stopTime){
                found = true
                colorizeTime(cellButton: innerButtons[i], active: true)
                break
            }
        }
        if (found == false){
            for i in (0 ... MainStartTimes.count - 2){
                if (MainStartTimes[i] == data.startTime && MainStopTimes[i] == data.stopTime){
                    found = true
                    updateTimes(main: true)
                    colorizeTime(cellButton: innerButtons[i], active: true)
                }
            }
        }
        if (found == false){
            colorizeView(view: TimeButtons[TimeButtons.count - 1], active: true)
            customStartTime.text = data.startTime
            customStopTime.text = data.stopTime
        }
    }
    
    //MARK: - updateTimes()
    func updateTimes (main: Bool){
        if (main){
            for i in (0 ... startTimes.count - 1){
                startTimes[i].text = MainStartTimes[i]
                stopTimes[i].text = MainStopTimes[i]
            }
        } else {
            for i in (0 ... startTimes.count - 1){
                startTimes[i].text = SStartTimes[i]
                stopTimes[i].text = SStopTimes[i]
            }
        }
    }
    
    //MARK: - playLight()
    func playLight(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    
    //MARK: - colorizeView()
    func colorizeView (view: UIView ,active: Bool){
        if (active){
            view.layer.borderColor = NNTUblue.cgColor
            view.layer.borderWidth = 3
        } else {
            view.layer.borderColor = nil
            view.layer.borderWidth = 0
        }
    }
    
    //MARK: colorizeButton()
    func colorizeButton (button: UIButton, active: Bool){
        colorizeView(view: button, active: active)
        if (active){
            button.setTitleColor(NNTUblue, for: .normal)
            playLight()
        } else {
            button.setTitleColor(.label, for: .normal)
        }
    }
    
    //MARK: colorizeTime()
    func colorizeTime (cellButton: UIButton, active: Bool){
        let index = innerButtons.firstIndex(of: cellButton) ?? 0
        colorizeView(view: TimeButtons[index], active: active)
        if (active){
            startTimes[index].textColor = NNTUblue
            stopTimes[index].textColor = NNTUblue
            playLight()
        } else {
            startTimes[index].textColor = .label
            stopTimes[index].textColor = .label
        }
    }
    
    
    //MARK: - NameChanged()
    @IBAction func NameChanged(_ sender: Any) {
        tempLesson.name = NameField.text ?? ""
    }
    
    //MARK: teacherChanged()
    @IBAction func teacherChanged(_ sender: UITextField) {
        tempLesson.teacher = sender.text ?? ""
    }
    
    //MARK: noteChanged()
    @IBAction func noteChanged(_ sender: UITextField) {
        tempLesson.notes = sender.text ?? ""
    }
    
    //MARK: customTypeChanged()
    @IBAction func customTypeChanged(_ sender: UITextField) {
        if (sender.text != ""){
            for i in (0 ... innerTypeButtons.count - 1){
                colorizeButton(button: innerTypeButtons[i], active: false)
            }
            colorizeView(view: TypeButtons[TypeButtons.count - 1], active: true)
            tempLesson.type = sender.text ?? ""
        }
    }
    
    //MARK: - customWeeksChanged()
    @IBAction func customWeeksChanged(_ sender: UITextField) {
        var input = sender.text ?? ""
        let odd = tempLesson.weeks.contains(-1)
        let even = tempLesson.weeks.contains(-2)
        var newWeeks = [Int]()
        if (input != ""){
            input = input.replacingOccurrences(of: " ", with: "")
            input = input.replacingOccurrences(of: "-", with: "")
            input = input.replacingOccurrences(of: "_", with: "")
            input = input.replacingOccurrences(of: "–", with: "")
            input = input.replacingOccurrences(of: ";", with: ",")
            input = input.replacingOccurrences(of: ".", with: ",")
            input = input.replacingOccurrences(of: ":", with: ",")
            colorizeView(view: WeekButtons[WeekButtons.count - 1], active: true)
            if (odd){ newWeeks.append(-1) }
            if (even){ newWeeks.append(-2) }
            while (input.contains(",")){
                let index = input.firstIndex(of: ",")!
                newWeeks.append(Int(String(input.prefix(upTo: index))) ?? 0)
                input = String(input.suffix(from: index).dropFirst())
            }
            newWeeks.append(Int(input) ?? 0)
            while (newWeeks.count > 1 && newWeeks.contains(0)){
                newWeeks.remove(at: newWeeks.firstIndex(of: 0)!)
            }
            tempLesson.weeks = newWeeks
        } else {
            colorizeView(view: WeekButtons[WeekButtons.count - 1], active: false)
        }
    }
    
    //MARK: customStartTimeChanged()
    @IBAction func customStartTimeChanged(_ sender: UITextField){
        var input = sender.text ?? ""
        if (input != ""){
            input = input.replacingOccurrences(of: " ", with: "")
            input = input.replacingOccurrences(of: ";", with: ":")
            input = input.replacingOccurrences(of: ".", with: ":")
            input = input.replacingOccurrences(of: ",", with: ":")
            input = input.replacingOccurrences(of: "/", with: ":")
            input = input.replacingOccurrences(of: "-", with: ":")
            input = input.replacingOccurrences(of: "_", with: ":")
            input = input.replacingOccurrences(of: "–", with: ":")
            for i in (0 ... innerButtons.count - 1){
                colorizeTime(cellButton: innerButtons[i], active: false)
            }
            colorizeView(view: TimeButtons[TimeButtons.count - 1], active: true)
            tempLesson.startTime = input
        }
    }
    
    //MARK: customStopTimeChanged()
    @IBAction func customStopTimeChanged(_ sender: UITextField){
        var input = sender.text ?? ""
        if (input != ""){
            input = input.replacingOccurrences(of: " ", with: "")
            input = input.replacingOccurrences(of: ";", with: ":")
            input = input.replacingOccurrences(of: ".", with: ":")
            input = input.replacingOccurrences(of: ",", with: ":")
            input = input.replacingOccurrences(of: "/", with: ":")
            input = input.replacingOccurrences(of: "-", with: ":")
            input = input.replacingOccurrences(of: "_", with: ":")
            input = input.replacingOccurrences(of: "–", with: ":")
            for i in (0 ... innerButtons.count - 1){
                colorizeTime(cellButton: innerButtons[i], active: false)
            }
            colorizeView(view: TimeButtons[TimeButtons.count - 1], active: true)
            tempLesson.stopTime = input
        }
    }
    
    //MARK: chooseTime()
    @IBAction func chooseTime(_ sender: UIButton) {
        colorizeTime(cellButton: sender, active: true)
        let index = innerButtons.firstIndex(of: sender) ?? 0
        tempLesson.startTime = startTimes[index].text ?? ""
        tempLesson.stopTime = stopTimes[index].text ?? ""
        for i in (0 ... TimeButtons.count - 1){
            if (i != index){
                if (i == TimeButtons.count - 1){
                    colorizeView(view: TimeButtons[TimeButtons.count - 1], active: false)
                } else {
                    colorizeTime(cellButton: innerButtons[i], active: false)
                }
            }
        }
    }
    
    
    
    //MARK: - roomChanged()
    @IBAction func roomChanged(_ sender: Any) {
        var input = roomField.text ?? ""
        let firstNumber = Int(String(input.first ?? "0")) ?? 0
        if (firstNumber == 6){
            updateTimes(main: false)
            for i in (0 ... MainStartTimes.count - 2){
                if (tempLesson.startTime == MainStartTimes[i] && tempLesson.stopTime == MainStopTimes[i]){
                    tempLesson.startTime = SStartTimes[i]
                    tempLesson.stopTime = SStopTimes[i]
                }
            }
        } else if (firstNumber < 6 && firstNumber > 0){
            updateTimes(main: true)
            for i in (0 ... SStartTimes.count - 2){
                if (tempLesson.startTime == SStartTimes[i] && tempLesson.stopTime == SStopTimes[i]){
                    tempLesson.startTime = MainStartTimes[i]
                    tempLesson.stopTime = MainStopTimes[i]
                }
            }
        }
        
        
        var newRooms = [String]()
        if (input != ""){
            input = input.replacingOccurrences(of: ";", with: ",")
            input = input.replacingOccurrences(of: ".", with: ",")
            input = input.replacingOccurrences(of: ":", with: ",")
            while (input.contains(",")){
                let index = input.firstIndex(of: ",")!
                newRooms.append(String(input.prefix(upTo: index)))
                input = String(input.suffix(from: index).dropFirst())
            }
            newRooms.append(input)
            while (newRooms.count > 1 && newRooms.contains("")){
                newRooms.remove(at: newRooms.firstIndex(of: "")!)
            }
            if (newRooms == [""]){
                newRooms = []
            }
            tempLesson.rooms = newRooms
        } else {
            colorizeView(view: WeekButtons[WeekButtons.count - 1], active: false)
            if (newRooms == [""]){
                newRooms = []
            }
            tempLesson.rooms = newRooms
        }
    }
    
    //MARK: - evenWeek()
    @IBAction func evenWeek(_ sender: UIButton) {
        if (tempLesson.weeks.contains(-2)){
            tempLesson.weeks.remove(at: tempLesson.weeks.firstIndex(of: -2) ?? 0)
            colorizeButton(button: sender, active: false)
        } else {
            tempLesson.weeks.append(-2)
            colorizeButton(button: sender, active: true)
        }
    }
    
    //MARK: oddWeek()
    @IBAction func oddWeek(_ sender: UIButton) {
        if (tempLesson.weeks.contains(-1)){
            tempLesson.weeks.remove(at: tempLesson.weeks.firstIndex(of: -1) ?? 0)
            colorizeButton(button: sender, active: false)
        } else {
            tempLesson.weeks.append(-1)
            colorizeButton(button: sender, active: true)
        }
    }
    
    //MARK: - lecture()
    @IBAction func lecture(_ sender: UIButton) {
        if (tempLesson.type == "Лекция"){
            tempLesson.type = ""
            colorizeButton(button: sender, active: false)
        } else {
            tempLesson.type = "Лекция"
            colorizeButton(button: sender, active: true)
            for i in (0 ... innerTypeButtons.count - 1){
                if (i != 0){
                    colorizeButton(button: innerTypeButtons[i], active: false)
                }
            }
            colorizeView(view: TypeButtons[TypeButtons.count - 1], active: false)
        }
    }
    
    //MARK: practice()
    @IBAction func practice(_ sender: UIButton) {
        if (tempLesson.type == "Практика"){
            tempLesson.type = ""
            colorizeButton(button: sender, active: false)
        } else {
            tempLesson.type = "Практика"
            colorizeButton(button: sender, active: true)
            for i in (0 ... innerTypeButtons.count - 1){
                if (i != 1){
                    colorizeButton(button: innerTypeButtons[i], active: false)
                }
            }
            colorizeView(view: TypeButtons[TypeButtons.count - 1], active: false)
        }
    }
    
    //MARK: laba()
    @IBAction func laba(_ sender: UIButton) {
        if (tempLesson.type == "Лаб.работа"){
            tempLesson.type = ""
            colorizeButton(button: sender, active: false)
        } else {
            tempLesson.type = "Лаб.работа"
            colorizeButton(button: sender, active: true)
            for i in (0 ... innerTypeButtons.count - 1){
                if (i != 2){
                    colorizeButton(button: innerTypeButtons[i], active: false)
                }
            }
            colorizeView(view: TypeButtons[TypeButtons.count - 1], active: false)
        }
    }
    
    
    @IBAction func Ready(_ sender: UIButton) {
        if (tempLesson.startTime == "" || tempLesson.stopTime == ""){
            let popup = UIAlertController(title: "Укажите время пары", message: "Время обязательно для нормальной огранизации занятий", preferredStyle: .alert)
            let kaction = UIAlertAction(title: "ОК", style: .default)
            popup.addAction(kaction)
            present(popup, animated: true)
            return
        }
        if (tempLesson.name == ""){
            let popup = UIAlertController(title: "Укажите название занятия", message: "Оно будет отображаться в расписании", preferredStyle: .alert)
            let kaction = UIAlertAction(title: "ОК", style: .default)
            popup.addAction(kaction)
            present(popup, animated: true)
            return
        }
        if (tempLesson.weeks == []){
            tempLesson.weeks = [-1, -2]
        }
        if (tempLesson.rooms == [""]){
            tempLesson.rooms = []
        }
        freeLesson = tempLesson
        self.dismiss(animated: true, completion: {
            TTeditorVC?.viewDidAppear(true)
            TTeditorVC = nil
        })
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
