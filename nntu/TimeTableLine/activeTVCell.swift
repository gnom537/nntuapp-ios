//
//  activeTVCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 23.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class activeTVCell: UITableViewCell {
    
    var data = emptyLesson()
    
    @IBOutlet var startTime : UILabel!
    @IBOutlet var stopTime : UILabel!
    @IBOutlet var name : UILabel!
    @IBOutlet var upperLabel : UILabel!
    @IBOutlet var lowerLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn(_ isBlue: Bool){
        if (isBlue){
            self.backgroundColor = UIColor(named: "NNTUblueBackground")
        } else {
            self.backgroundColor = UIColor(named: "NNTUredBackground")
        }
        var upperText = [String]()
        if (data.weeks.contains(-2) && data.weeks.contains(-1)){
            upperText.append("ЧН + НЧ")
        } else if (data.weeks.contains(-1)){
            upperText.append("НЧ")
        } else if (data.weeks.contains(-2)){
            upperText.append("ЧН")
        }
        var added = 0
        var tempString = ""
        if (data.weeks.count > 0){
            for i in (0 ... data.weeks.count - 1){
                if (data.weeks[i] > 0){
                    tempString += String(data.weeks[i]) + ", "
                    added += 1
                }
            }
            if (added == 1){
                tempString += " НЕДЕЛЯ"
                upperText.append(tempString)
            } else if (added > 1){
                tempString += " НЕДЕЛИ"
                upperText.append(tempString)
            }
        }
        upperText.append(data.type)
        upperText.append(data.notes)
        tempString = ""
        for i in (0 ... upperText.count - 1){
            if (upperText[i] != ""){
                tempString += upperText[i] + "; "
            }
        }
        if (tempString != ""){
            tempString = String(tempString.dropLast(2))
        }
        let colorfulS = NSMutableAttributedString(string: tempString.uppercased())
        colorfulS.setColorForText(textForAttribute: "НЧ", withColor: NNTUred)
        colorfulS.setColorForText(textForAttribute: "ЧН", withColor: NNTUblue)
        
        
        startTime.text = data.startTime
        stopTime.text = data.stopTime
        name.text = data.name
        upperLabel.attributedText = colorfulS
        if (data.rooms.count > 0 && data.rooms != [""]){
            lowerLabel.text = stringFromRooms(rooms: data.rooms).replacingOccurrences(of: ",", with: ", ").uppercased() + "; " + data.teacher.uppercased()
        } else {
            lowerLabel.text = data.teacher.uppercased()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
