//
//  TeacherDataPairCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TeacherDataPairCell: UITableViewCell {
    
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn(_ data:(String, String)){
        keyLabel.text = data.0
        valueLabel.text = data.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
