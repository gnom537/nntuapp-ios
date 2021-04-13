//
//  SingleMarkViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 11.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class SingleMarkViewController: UIViewController {
    
    @IBOutlet var DisName: UILabel?
    @IBOutlet var ResType: UILabel!
    @IBOutlet var Result: UILabel!
    @IBOutlet var FirstKn: UILabel!
    @IBOutlet var SecondKn: UILabel!
    @IBOutlet var PropFkn: UILabel!
    @IBOutlet var PropSkn: UILabel!
    
    
    var inputCell : MarkCell?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screen = UIScreen.main
        if (screen.bounds.width <= 350){
            DisName?.font! = DisName?.font.withSize(27) as! UIFont
        }
        DisName?.text = inputCell?.DisName.text
        ResType.text = inputCell?.typeName.text
        Result.text = inputCell?.Result
        FirstKn.text = inputCell?.FirstKn
        if (FirstKn.text == nil){
            FirstKn.text = "0"
            FirstKn.alpha = 0.1
        }
        SecondKn.text = inputCell?.SecondKn
        if (SecondKn.text == nil){
            SecondKn.text = "0"
            SecondKn.alpha = 0.1
        }
        PropFkn.text = inputCell?.PropFirstKn
        if (PropFkn.text == nil){
            PropFkn.text = "0"
            PropFkn.alpha = 0.1
        }
        PropSkn.text = inputCell?.PropSecondKn
        if (PropSkn.text == nil){
            PropSkn.text = "0"
            PropSkn.alpha = 0.1
        }
        if (inputCell?.Result != nil){
            ResType.text?.append(":")
            if (inputCell?.Result == "зачёт"){
                Result.text = "сдан 🥳"
            }
        }
        if (inputCell?.Result != nil){
            Result.textColor = .systemGreen
            if (inputCell?.Result == "5"){
                Result.text?.append(" 🥳")
            }
        }
        
        
        
        // Do any additional setup after loading the view.
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
