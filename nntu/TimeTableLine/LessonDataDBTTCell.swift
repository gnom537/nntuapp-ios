//
//  LessonDataDBTTCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 25.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class LessonDataDBTTCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var weeksLabel: UILabel!
    @IBOutlet var typenNotesLabel: UILabel!
    @IBOutlet var teacherLabel: UILabel!
    @IBOutlet var roomsLabel: UILabel!
    
    @IBOutlet var teacherCAPSLabel: UILabel!
    @IBOutlet var roomsCAPSLabel: UILabel!
    
    var data : Lesson = emptyLesson()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillIn(){
        var weekString = ""
        if (data.weeks.contains(-2)){
            weekString += "Четные недели"
            if (data.weeks.contains(-1)){
                weekString += " + "
            }
            weekString += "\n"
        }
        if (data.weeks.contains(-1)){
            weekString += "Нечетные недели\n"
        }
        if (data.weeks.count > 0){
            var added = 0
            for i in (0 ... data.weeks.count - 1){
                if (data.weeks[i] > 0){
                    weekString += String(data.weeks[i]) + ", "
                    added += 1
                }
            }
            if (added > 0){
                weekString = String(weekString.dropLast(2))
                if (added == 1){
                    weekString += " неделя"
                } else {weekString += " недели"}
            } else {
                weekString = String(weekString.dropLast())
            }
        }
        let colorfulS = NSMutableAttributedString(string: weekString.uppercased())
        colorfulS.setColorForText(textForAttribute: "Четные недели".uppercased(), withColor: NNTUblue)
        colorfulS.setColorForText(textForAttribute: "Нечетные недели".uppercased(), withColor: NNTUred)
        
        nameLabel.text = data.name
        var notes = ", " + data.notes
        if (notes == ", ") {notes = ""}
        typenNotesLabel.text = (data.type + notes).uppercased()
        dayLabel.text = DaysOfWeek[data.day].uppercased()
        timeLabel.text = "\(data.startTime) – \(data.stopTime)"
        weeksLabel.attributedText = colorfulS
        roomsLabel.text = stringFromRooms(rooms: data.rooms).replacingOccurrences(of: ",", with: ", ")
        teacherLabel.text = data.teacher
        if (roomsLabel.text == ""){
            roomsLabel.isHidden = true
            roomsCAPSLabel.isHidden = true
        }
        if (teacherLabel.text == ""){
            teacherLabel.isHidden = true
            teacherCAPSLabel.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
