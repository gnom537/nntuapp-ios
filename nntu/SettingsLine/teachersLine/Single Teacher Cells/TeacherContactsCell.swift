//
//  TeacherContactsCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TeacherContactsCell: UITableViewCell {
    
    @IBOutlet var contactTypeLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var buttonShape: UIView!
    
    var type = String()
    var value = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonShape.layer.cornerRadius = 7
        // Initialization code
    }
    
    func fillIn(_ data:(String, String)){
        type = data.0
        value = data.1
        
        contactTypeLabel.text = type
        valueLabel.text = value
    }
    
    @IBAction func openContact(_ sender: UIButton) {
        print("Я работаю: \(type)")
        if type == "Электронная почта" {
            if let url = URL(string: "mailto:\(value)"){
                UIApplication.shared.open(url)
            }
        } else if type == "Контактный телефон" {
            var phone = value.replacingOccurrences(of: " ", with: "")
            phone = phone.replacingOccurrences(of: "-", with: "")
            phone = phone.replacingOccurrences(of: "(", with: "")
            phone = phone.replacingOccurrences(of: ")", with: "")
            phone = phone.replacingOccurrences(of: "+7", with: "8")
            if let url = URL(string: "tel://\(phone)"){
                UIApplication.shared.open(url)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
