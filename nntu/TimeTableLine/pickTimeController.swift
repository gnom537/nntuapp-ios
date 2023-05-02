//
//  pickTimeController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 25.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class pickTimeController: UIViewController {
    
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet var plusWeek: UIButton!
    @IBOutlet var minusWeek: UIButton!
    @IBOutlet var nowDay: UIButton!
    
//    var dayDifference = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let radius: CGFloat = 5
        picker.date = Date()
        plusWeek.layer.cornerRadius = radius
        minusWeek.layer.cornerRadius = radius
        nowDay.layer.cornerRadius = radius
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickerChanged(_ sender: UIDatePicker) {
        dateForTT = sender.date
    }
    
    @IBAction func nowDayButton(_ sender: Any) {
        picker.date = Date()
        dateForTT = picker.date
    }
    
    @IBAction func plusWeekButton(_ sender: Any) {
        picker.date = picker.date.advanced(by: Double(604800))
        dateForTT = picker.date
    }
    
    @IBAction func minusWeekButton(_ sender: Any) {
        picker.date = picker.date.advanced(by: Double(-604800))
        dateForTT = picker.date
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            freeDBTTController?.datePicked()
            freeDBTTController = nil
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
