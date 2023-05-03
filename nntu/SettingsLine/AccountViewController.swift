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

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    var tempEntered = false
    
    
    //MARK: - IBOutlets
    @IBOutlet var accountView: UIView!
    @IBOutlet var moreStack: UIStackView!
    
    
    //TextFields
    @IBOutlet var InputStack: UIStackView!
    @IBOutlet var SecondName: UITextField!
    @IBOutlet var FirstName: UITextField!
    @IBOutlet var Otchestvo: UITextField!
    @IBOutlet var Nstud: UITextField!
    @IBOutlet var Group: UITextField!

    @IBOutlet var ErrorLabel: UILabel!
    
    // кнопки
    @IBOutlet var EnterButton: UIView!
    @IBOutlet var EditButton: UIView!
    @IBOutlet var EnterButtonTitle: UILabel!
    @IBOutlet var EnterButtonIcon: UILabel!
    
    
//    @IBOutlet var goToSettingsButton: UIButton!
    
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
//    @IBOutlet var Margin: NSLayoutConstraint!
//    @IBOutlet var MarginLeading: NSLayoutConstraint!
    
    //для того, чтобы скрывать текст у преподов
    @IBOutlet var NStudStack: UIStackView!
    @IBOutlet var UselessGroupLabel: UILabel!
    
    
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
        
        moreStack.clipsToBounds = true
        moreStack.layer.cornerRadius = 20
        accountView.layer.cornerRadius = 20
        accountView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        entered = data.bool(forKey: "Entered")
        tempEntered = entered
        
        if (entered == false){
            OutputStack.isHidden = true
            InputStack.isHidden = false
            FirstName.isHidden = false
            SecondName.isHidden = false
            Otchestvo.isHidden = false
            Nstud.isHidden = false
            Group.isHidden = false
            EditButton.isHidden = true
            ErrorLabel.isHidden = true
            
            EnterButtonTitle.text = NSLocalizedString("Войти", comment: "")
            EnterButtonTitle.textColor = .systemBlue
            EnterButtonIcon.text = "✅"
            
            let tabConfig = TabBarConfig.notAuthorized
            self.tabBarController?.apply(tabConfig, vcs: tabBarVCs)
        }
        
        
        else{
//            updateNames()
            //isHidden
            OutputStack.isHidden = false
            InputStack.isHidden = true
            ErrorLabel.isHidden = true
            EditButton.isHidden = false
            EnterButtonTitle.text = "Выйти"
            EnterButtonTitle.textColor = .systemRed
            EnterButtonIcon.text = "❌"
            
            //Достаем данные и после этого наведем красоту
            NameLabel.text = data.string(forKey: "FirstName") ?? "null"
            SecondNameLabel.text = data.string(forKey: "SecondName") ?? "null"
            OtchLabel.text = data.string(forKey: "Otchestvo")
            NumLabel.text = data.string(forKey: "Nstud")
            GroupLabel.text = data.string(forKey: "Group")
            
            if (data.string(forKey: "Nstud") == ""){
                NStudStack.isHidden = true
                GroupLabel.isHidden = true
                UselessGroupLabel.text = NSLocalizedString("Преподаватель", comment: "")
            } else {
                NStudStack.isHidden = false
                GroupLabel.isHidden = false
                UselessGroupLabel.text = NSLocalizedString("Группа:", comment: "")
            }
            
            let tabConfig = TabBarConfig.from(entered: entered, nstud: data.string(forKey: "Nstud"))
            self.tabBarController?.apply(tabConfig, vcs: tabBarVCs)
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
                EnterButtonTitle.text = NSLocalizedString("Войти", comment: "")
                EnterButtonTitle.textColor = .systemBlue
                EnterButtonIcon.text = "✅"
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
    
    
    //MARK: - editUserData()
    @IBAction func editUserData(_ sender: UIButton) {
        EnterButtonTitle.text = NSLocalizedString("Войти", comment: "")
        EnterButtonTitle.textColor = .systemBlue
        EnterButtonIcon.text = "✅"
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
    
}

