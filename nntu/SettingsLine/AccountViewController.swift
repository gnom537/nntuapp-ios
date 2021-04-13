//
//  SecondViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 16.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

extension String {
    func capitalize() -> String {
        var output = self
        output = output.uppercased()
        output = output.replacingOccurrences(of: " ", with: "-")
        return output
    }
}

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    var tempEntered = false
    
    
    //MARK: - IBOutlets
    //TextFields
    @IBOutlet var InputStack: UIStackView!
    @IBOutlet var SecondName: UITextField!
    @IBOutlet var FirstName: UITextField!
    @IBOutlet var Otchestvo: UITextField!
    @IBOutlet var Nstud: UITextField!
    @IBOutlet var Group: UITextField!

    @IBOutlet var ErrorLabel: UILabel!
    @IBOutlet var EnterButton: UIButton!
    @IBOutlet var EditButton: UIButton!
    @IBOutlet var ChangeTimeTableButton: UIButton!
    
    //это мы будем прятать и обратно доставать
    @IBOutlet var OutputStack: UIStackView!
    
    //большие фио
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var SecondNameLabel: UILabel!
    @IBOutlet var OtchLabel: UILabel!
    
    //номер студака и группа
    @IBOutlet var NumLabel: UILabel!
    @IBOutlet var GroupLabel: UILabel!
    
    //для наведения красоты
    @IBOutlet var Margin: NSLayoutConstraint!
    @IBOutlet var MarginLeading: NSLayoutConstraint!
    
    //для того, чтобы скрывать текст у преподов
    @IBOutlet var NStudStack: UIStackView!
    @IBOutlet var UselessGroupLabel: UILabel!
    
    
    var size : CGFloat = 17
    
    let data = UserDefaults.standard
 
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondName.delegate = self
        SecondName.autocapitalizationType = .words
        FirstName.delegate = self
        FirstName.autocapitalizationType = .words
        Otchestvo.delegate = self
        Otchestvo.autocapitalizationType = .words
        Nstud.delegate = self
        Group.delegate = self
        
        EnterButton.layer.cornerRadius = 7
        EditButton.layer.cornerRadius = 7
        ChangeTimeTableButton.layer.cornerRadius = 7
        Entered = data.bool(forKey: "Entered")
        tempEntered = Entered
        
        let width = UIScreen.main.bounds.width - 30
        if (width <= 345){
            Margin.constant = 15
            MarginLeading.constant = 15
        } else {
            Margin.constant = 20
            MarginLeading.constant = 20
        }
        
        //TabBar = self.tabBarController?.viewControllers
        if (Entered == false){
            OutputStack.isHidden = true
            FirstName.isHidden = false
            SecondName.isHidden = false
            Otchestvo.isHidden = false
            Nstud.isHidden = false
            Group.isHidden = false
            EditButton.isHidden = true
            ErrorLabel.isHidden = true
//            if (self.tabBarController?.viewControllers?.count == 5 || self.tabBarController?.viewControllers?.count == 4){
//                self.tabBarController?.viewControllers?.remove(at: 1)
//                if (self.tabBarController?.viewControllers?.count == 4){
//                    self.tabBarController?.viewControllers?.remove(at: 1)
//                }
//            }
            if (self.tabBarController?.viewControllers?.count == 5){
                self.tabBarController?.viewControllers?.remove(at: 1)
//                self.tabBarController?.viewControllers?.remove(at: 2)
            }
//            else if (self.tabBarController?.viewControllers?.count == 4) {
//                self.tabBarController?.viewControllers?.remove(at: 2)
//            }
            
            ChangeTimeTableButton.isHidden = true
        }
        
        
        else{
            size = 17
            updateNames()
            //isHidden
            OutputStack.isHidden = false
            FirstName.isHidden = true
            SecondName.isHidden = true
            Otchestvo.isHidden = true
            Nstud.isHidden = true
            Group.isHidden = true
            ErrorLabel.isHidden = true
            ChangeTimeTableButton.isHidden = false
            EditButton.isHidden = false
            
            //заполнение Output Stack
            EnterButton.setTitle(NSLocalizedString("Выйти", comment: ""), for: .normal)
            EnterButton.setTitleColor(UIColor.red, for: .normal)
            
            //Достаем данные и после этого наведем красоту
            NameLabel.text = data.string(forKey: "FirstName") ?? "null"
            SecondNameLabel.text = data.string(forKey: "SecondName") ?? "null"
            OtchLabel.text = data.string(forKey: "Otchestvo")
            NumLabel.text = data.string(forKey: "Nstud")
            GroupLabel.text = data.string(forKey: "Group")
            
            //Находим самое длинное слово для того, чтобы потом по нему масштабировать текст под ширину стека
            let maxLength = [NameLabel.text?.count ?? 0, SecondNameLabel.text?.count ?? 0, OtchLabel.text?.count ?? 0].max()!
            
            
            //по самому длинному слову определяем ширину стека
            var textWidth : CGFloat = 0
            if (OtchLabel.text?.count ?? 0 == maxLength){
                textWidth = OtchLabel.intrinsicContentSize.width
            } else if (NameLabel.text?.count ?? 0 == maxLength){
                textWidth = NameLabel.intrinsicContentSize.width
            } else {
                textWidth = SecondNameLabel.intrinsicContentSize.width
            }
            
            size = 17
            while (textWidth < width - 80 && size < 83){
                size = size + 1
                updateNames()
                if (OtchLabel.text?.count ?? 0 == maxLength){
                    textWidth = OtchLabel.intrinsicContentSize.width
                } else if (NameLabel.text?.count ?? 0 == maxLength){
                    textWidth = NameLabel.intrinsicContentSize.width
                } else {
                    textWidth = SecondNameLabel.intrinsicContentSize.width
                }
            }
            
//            NameLabel.text = "\(data.string(forKey: "SecondName") as? String ?? "null") \(data.string(forKey: "FirstName") as? String ?? "null") \(data.string(forKey: "Otchestvo") as? String ?? "null")"
//            NumLabel.text = "номер студенческого билета: \(data.string(forKey: "Nstud") as? String ?? "null")"
//            GroupLabel.text = "группа:  \(data.string(forKey: "Group")as? String ?? "null")"
            self.tabBarController?.viewControllers = TabBar
            if (data.string(forKey: "Nstud") == ""){
                self.tabBarController?.viewControllers?.remove(at: 1)
                NStudStack.isHidden = true
                GroupLabel.isHidden = true
                UselessGroupLabel.text = NSLocalizedString("Преподаватель", comment: "")
            } else {
                NStudStack.isHidden = false
                GroupLabel.isHidden = false
                UselessGroupLabel.text = NSLocalizedString("Группа:", comment: "")
            }
        }
    }
    
    //MARK: disableKeyboard()
    func disableKeyboard(){
        SecondName.endEditing(true)
        FirstName.endEditing(true)
        Otchestvo.endEditing(true)
        Nstud.endEditing(true)
        Group.endEditing(true)
    }
    
    //MARK: tapHappened()
    @IBAction func TapHappened(_ sender: Any) {
        disableKeyboard()
    }
    
    //MARK: - checkEverything()
    func checkEverything(isPrepod: Bool) -> Bool {
        func checkField (a: UITextField) -> Bool {
            if (a.text == nil || a.text == "") {
                return false
            }
            else {return true}
        }
        if (checkField(a: SecondName) == false) {return false}
        else if (checkField(a: FirstName) == false) {return false}
        else if (checkField(a: Nstud) == false && isPrepod == false) {return false}
        else if (checkField(a: Group) == false && isPrepod == false) {return false}
        else {return true}
    }
    
    //MARK:- clearFromSpaces()
    func clearFromSpaces(a : String?) -> String? {
        var input: String = a ?? " "
        while (input.last == " "){
            input.remove(at: input.index(before: input.endIndex))
        }
        while (input.first == " "){
            input.remove(at: input.index(after: input.startIndex))
        }
        return input
    }
    
    //MARK: - textFieldShouldReturn()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case SecondName:
            FirstName.becomeFirstResponder()
        case FirstName:
            Otchestvo.becomeFirstResponder()
        case Otchestvo:
            Nstud.becomeFirstResponder()
        case Nstud:
            Group.becomeFirstResponder()
        case Group:
            Group.resignFirstResponder()
            EnterButton(EnterButton!)
        default:
            print("код не найден")
        }
        return false
    }
    
    
    
    
    
    //MARK: - EnterButton()
    @IBAction func EnterButton(_ sender: Any) {
        disableKeyboard()
       
        if (tempEntered == false){
            
            let autoUpdate = data.integer(forKey: "autoUpdate")
            if (autoUpdate == 0){
                data.set(1, forKey: "autoUpdate")
            }
            
            
            var isPrepod = false
            
            func saveTheFields(){
                data.set(clearFromSpaces(a: SecondName.text), forKey: "SecondName")
                data.set(clearFromSpaces(a: FirstName.text), forKey: "FirstName")
                data.set(clearFromSpaces(a: Otchestvo.text), forKey: "Otchestvo")
                data.set(clearFromSpaces(a: Nstud.text), forKey: "Nstud")
                data.set(clearFromSpaces(a: Group.text)?.capitalize(), forKey: "Group")
                
                let widgetUserDefaults = UserDefaults(suiteName: BUNDLEGROUP)
//                widgetUserDefaults?.setValue((Group.text)?.capitalize(), forKey: "Group")
                widgetUserDefaults?.set(clearFromSpaces(a: Group.text)?.capitalize() as AnyObject, forKey: "Group")
                
                data.set(true, forKey: "Entered")
                
                let genator = UINotificationFeedbackGenerator()
                genator.notificationOccurred(.success)
            }
            
            func iAmPrepod(){
                isPrepod = true
                if (checkEverything(isPrepod: isPrepod) == false){
                    ErrorLabel.isHidden = false
                }
                else {
                    saveTheFields()
                    data.set("\(SecondName.text ?? "null")-\(FirstName.text ?? "null")-\(Otchestvo.text ?? "null")".capitalize(), forKey: "Group")
                    data.set("", forKey: "Nstud")
                    data.set("prepod", forKey: "UserType")
                    viewDidLoad()
                }
            }
            
            func bakalavr() {
                if (checkEverything(isPrepod: isPrepod) == false){
                    ErrorLabel.isHidden = false
                }
                else {
                    saveTheFields()
                    data.set("bak_spec", forKey: "UserType")
                    viewDidLoad()
                }
            }
            
            func magistr() {
                if (checkEverything(isPrepod: isPrepod) == false){
                    ErrorLabel.isHidden = false
                }
                else {
                    saveTheFields()
                    data.set("mag", forKey: "UserType")
                    viewDidLoad()
                }
            }
            
            let popup = UIAlertController(title: NSLocalizedString("Кем вы являетесь?", comment: ""), message: .none , preferredStyle: .actionSheet)
            
            let bakAction = UIAlertAction(title: NSLocalizedString("Студент бакалавриата/специалитета", comment: ""), style: .default){
                action in
                bakalavr()
            }
            let magAction = UIAlertAction(title: NSLocalizedString("Студент магистратуры", comment: ""), style: .default){
                action in
                magistr()
            }
            let prepAction = UIAlertAction(title: NSLocalizedString("Преподаватель", comment: ""), style: .default){
                action in
                iAmPrepod()
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel)
            
            
            
            popup.addAction(prepAction)
            popup.addAction(magAction)
            popup.addAction(bakAction)
            
            popup.addAction(cancel)
            
            present(popup, animated: true)
        }
        else {
            func leave(){
                EnterButton.setTitle(NSLocalizedString("Войти", comment: ""), for: .normal)
                EnterButton.setTitleColor(.systemBlue, for: .normal)
                data.set("", forKey: "SecondName")
                data.set("", forKey: "FirstName")
                data.set("", forKey: "Otchestvo")
                data.set("", forKey: "Nstud")
                data.set("", forKey: "Group")
                data.set(false, forKey: "Entered")
                clearFields()
                CoreDataStack.shared.clearCoreData()
                viewDidLoad()
            }
            
            let popup = UIAlertController(title: NSLocalizedString("Вы уверены?", comment: ""), message: nil, preferredStyle: .actionSheet)
            let leaveAction = UIAlertAction(title: NSLocalizedString("Выйти", comment: ""), style: .destructive){
                action in
                leave()
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel)
            
            popup.addAction(leaveAction)
            popup.addAction(cancelAction)
            present(popup, animated: true)
        }
    }
    
    
    var prevNstud = 0
    @IBAction func addTire(_ sender: Any){
        let NstudText = Nstud.text ?? ""
        if (NstudText.count == 2 && Int(NstudText) ?? 0 >= 20){
            if (prevNstud < NstudText.count){
                Nstud.text = NstudText + "-"
            } else {
                Nstud.text = String(NstudText.dropLast(1))
            }
        }
        if (NstudText.last == "-"){
            Nstud.text = String(NstudText.dropLast(1))
        }
        prevNstud = (Nstud.text ?? "").count
    }
    
    //MARK: - updateNames
    func updateNames(){
        NameLabel.font = NameLabel.font.withSize(size)
        SecondNameLabel.font = SecondNameLabel.font.withSize(size)
        OtchLabel.font = OtchLabel.font.withSize(size)
    }
    
    //MARK: - editUserData()
    @IBAction func editUserData(_ sender: UIButton) {
        EnterButton.setTitle(NSLocalizedString("Войти", comment: ""), for: .normal)
        EnterButton.setTitleColor(.systemBlue, for: .normal)
        SecondName.text = SecondNameLabel.text
        FirstName.text = NameLabel.text
        Otchestvo.text = OtchLabel.text
        Nstud.text = NumLabel.text
        Group.text = GroupLabel.text
        data.set(false, forKey: "Entered")
        viewDidLoad()
    }
    
    func clearFields(){
        SecondName.text = ""
        FirstName.text = ""
        Otchestvo.text = ""
        Nstud.text = ""
        Group.text = ""
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        viewDidLoad()
//    }
    
}

