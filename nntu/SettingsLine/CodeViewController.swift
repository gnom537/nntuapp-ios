//
//  CodeViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 24.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class CodeViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var CodeField: UITextField!
    @IBOutlet var UpperLabel: UILabel!
    @IBOutlet var EnterButton: UIButton!
    @IBOutlet var VKButton : UIButton!
    @IBOutlet var EmailButton : UIButton!
    @IBOutlet var EditorButton: UIButton!
    
    let data = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let radius: CGFloat = 5
        EnterButton.layer.cornerRadius = radius
        VKButton.layer.cornerRadius = radius
        EmailButton.layer.cornerRadius = radius
        EditorButton.layer.cornerRadius = radius
        CodeField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goToEditor(_ sender: Any) {
        performSegue(withIdentifier: "RightAnswer", sender: (Any).self)
    }
    

    @IBAction func CheckInfo(_ sender: Any) {
        CodeField.endEditing(true)
//        var UserGroup = data.string(forKey: "Group")
//        if (UserGroup != nil && UserGroup != ""){
//            UserGroup = encrypt(input: UserGroup)
//            let CodeGroup = CodeField.text
//            if (CodeGroup != nil && CodeGroup != ""){
//                //CodeGroup = encrypt(input: CodeGroup)
//                if (CodeGroup == UserGroup){
//
//                    let genator = UINotificationFeedbackGenerator()
//                    genator.notificationOccurred(.success)
//
////                    performSegue(withIdentifier: "RightAnswer", sender: (Any).self)
//                } else {
//                    print (CodeGroup ?? "")
//                    print (UserGroup ?? "")
//                    if (CodeField.text?.lowercased().contains("с пасхой") == true){
//                        openEaster()
//                    } else {
//                        UpperLabel.text = NSLocalizedString("Неверный код", comment: "")
//                        UpperLabel.textColor = UIColor.red
//
//                        let genator = UINotificationFeedbackGenerator()
//                        genator.notificationOccurred(.error)
//                    }
//                }
//            } else {
//                print (UserGroup!)
//                //performSegue(withIdentifier: "RightAnswer", sender: (Any).self)
//                UpperLabel.text = NSLocalizedString("Введите код!", comment: "")
//                UpperLabel.textColor = UIColor.systemRed
//
//                let genator = UINotificationFeedbackGenerator()
//                genator.notificationOccurred(.error)
//            }
//        } else {
//            UpperLabel.text = NSLocalizedString("Вход не выполнен", comment: "")
//            UpperLabel.textColor = UIColor.systemRed
//        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    @IBAction func OpenVKGroup(_ sender: UIButton) {
        CodeField.endEditing(true)
        if let url = URL(string: "https://vk.com/nntuapp"){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func OpenEmail (_ sender: UIButton){
        CodeField.endEditing(true)
        let email = "nntuapp@inbox.ru"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openEaster(){
        let email = URL(string: "https://www.youtube.com/watch?v=G6pqAN8ALC8&t=33s")!
        let genator = UINotificationFeedbackGenerator()
        genator.notificationOccurred(.success)
        UIApplication.shared.open(email)
    }
    
    @IBAction func tapHappened(_ sender: Any) {
        CodeField.endEditing(true)
    }
    
    @IBAction func infoButton(_ sender: Any) {
        let ok = UIAlertAction(title: NSLocalizedString("Понятно", comment: ""), style: .default)
        let popup = UIAlertController(title: NSLocalizedString("Зачем нужен код?", comment: ""), message: NSLocalizedString("Сообщение с кодом", comment: ""), preferredStyle: .alert)
        popup.addAction(ok)
        present(popup, animated: true)
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
