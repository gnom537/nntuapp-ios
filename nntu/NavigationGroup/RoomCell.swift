//
//  RoomCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 05.08.2020.
//  Copyright © 2020 Алексей Шерстнев. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {
    
    @IBOutlet var roomName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
