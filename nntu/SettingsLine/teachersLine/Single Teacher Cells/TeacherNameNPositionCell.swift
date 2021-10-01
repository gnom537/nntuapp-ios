//
//  TeacherNameNPositionCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TeacherNameNPositionCell: UITableViewCell {
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var PositionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn(_ data: (String, String)){
        let name = data.0.replacingOccurrences(of: " ", with: "\n")
        NameLabel.text = name
        PositionLabel.text = data.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
