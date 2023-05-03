//
//  CodeDBViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 22.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit
import WidgetKit

class CodeDBViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var autoUpdateSwitch: UISwitch!
    @IBOutlet var CodeField: UITextField!
    
    @IBOutlet var areAllActiveSwitch: UISwitch!
    @IBOutlet var calendarSwitch: UISwitch!
    
    private let calendarManager = CalendarManager()
    let data = UserDefaults.standard
    var calendar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        areAllActiveSwitch.isOn = UserDefaults.standard.bool(forKey: "areAllActive")
        calendarSwitch.isOn = UserDefaults.standard.bool(forKey: "CalendarTransfer")
        calendar = calendarSwitch.isOn
        autoUpdateSwitch.isOn = checkAutoUpdate()
        AUSwitch = autoUpdateSwitch
    }

    @IBAction func automaticUpdatesChanded(_ sender: UISwitch) {
        if (sender.isOn){
            data.setValue(1, forKey: "autoUpdate")
        } else {
            data.setValue(-1, forKey: "autoUpdate")
        }
    }
    
    @IBAction func allActiveChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "areAllActive")
    }
    
    @IBAction func calendarTranferChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "CalendarTransfer")
        calendar = sender.isOn
        self.tableView.reloadData()
        if (sender.isOn == false){
            let alert = UIAlertController(title: NSLocalizedString("Расписание еще в календаре", comment: ""), message: NSLocalizedString("Удалять календарь?", comment: ""), preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Удалить", comment: ""), style: .destructive, handler: {[weak self] _ in
                guard let self else { return }
                let calendarIdentifier = self.calendarManager.getCalendar().calendarIdentifier
                self.calendarManager.removeTTfromCalendar(id: calendarIdentifier)
            })
            let retainAction = UIAlertAction(title: NSLocalizedString("Оставить", comment: ""), style: .default, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(retainAction)
            present(alert, animated: true, completion: nil)
        } else {
            calendarManager.putTTinCalendar(tt: CoreDataStack.shared.fetchLessons())
        }
    }
    
    
    
    func checkAutoUpdate() -> Bool{
        let state = data.integer(forKey: "autoUpdate") 
        if (state == 1){
            return true
        } else { return false }
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        var userGroup = data.string(forKey: "Group") ?? ""
        if (userGroup != "" && CodeField.text ?? "" != ""){
            userGroup = encrypt(input: userGroup) ?? ""
            let encrypedTire = encrypt(input: "-") ?? ""
            userGroup = userGroup.replacingOccurrences(of: encrypedTire, with: "")
            let typedCode = CodeField.text?.replacingOccurrences(of: encrypedTire, with: "")
            
            if (userGroup == typedCode){
                successFeedback()
                CodeField.resignFirstResponder()
                uploadTT(CoreDataStack.shared.fetchLessons(), groupName: self.data.string(forKey: "Group") ?? "", comletition: {conn in
                    var text = ""
                    var title = ""
                    if (conn){
                        title = "Расписание загружено 👌"
                        text = "Теперь любой желающий может ввести группу \(self.data.string(forKey: "Group") ?? "") и увидеть добавленное вами расписание 😎"
                        self.data.setValue(1, forKey: "autoUpdate")
                        self.autoUpdateSwitch.isOn = true
                        if #available(iOS 14.0, *) {
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    } else {
                        title = "Ошибка соединения 😳"
                        text = "Произошла ошибка соединения с сервером. Проверьте свое соединение"
                    }
                    let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
                    let popup = UIAlertController(title: title, message: text, preferredStyle: .alert)
                    popup.addAction(ok)
                    self.present(popup, animated: true)
                })
                CodeField.placeholder = "Код"
            } else if (CodeField.text?.lowercased().contains("пасх") == true){
                openEaster()
            } else {
                errorFeedback()
                print(encrypt(input: userGroup) ?? "")
                CodeField.text = ""
                CodeField.placeholder = "Неверный код!"
            }
        } else if (CodeField.text ?? "" == ""){
            errorFeedback()
            print(encrypt(input: userGroup) ?? "")
            CodeField.placeholder = "Введите код!"
        } else {
            errorFeedback()
            CodeField.placeholder = "Группа не указана"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        CodeField.resignFirstResponder()
        return false
    }
    
    func openEaster(){
        let email = URL(string: "https://www.youtube.com/watch?v=G6pqAN8ALC8&t=33s")!
        let genator = UINotificationFeedbackGenerator()
        genator.notificationOccurred(.success)
        UIApplication.shared.open(email)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 3){
            if (indexPath.row == 1) {
                CodeField.endEditing(true)
                if let url = URL(string: "https://vk.com/nntuapp"){
                    UIApplication.shared.open(url)
                }
            } else if (indexPath.row == 0){
                CodeField.endEditing(true)
                let email = "nntuapp@inbox.ru"
                if let url = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Футер автозагрузки", comment: "")
        case 1:
            if (calendar){
                return NSLocalizedString("Активный футер календаря", comment: "")
            } else {
                return NSLocalizedString("Пассивный футер календаря", comment: "")
            }
        case 2:
            return NSLocalizedString("Футер загрузки на сервер", comment: "")
        case 3:
            return NSLocalizedString("Кредитс", comment: "")
        default:
            return nil
        }
    }
}
