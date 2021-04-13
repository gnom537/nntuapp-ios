//
//  passiveTVCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 23.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class passiveTVCell: UITableViewCell {
    
    var data = emptyLesson()
    
    @IBOutlet var startTime : UILabel!
    @IBOutlet var stopTime : UILabel!
    @IBOutlet var name : UILabel!
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
        startTime.text = data.startTime
        stopTime.text = data.stopTime
        name.text = data.name
        if (data.type != "" && data.rooms.count > 0){
            lowerLabel.text = stringFromRooms(rooms: data.rooms).replacingOccurrences(of: "", with: ",").uppercased() + ", " + data.type.uppercased()
        } else if (data.rooms.count > 0){
            lowerLabel.text = stringFromRooms(rooms: data.rooms).replacingOccurrences(of: "", with: ",").uppercased()
        } else {
            lowerLabel.text = data.type.uppercased()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
