//
//  TeacherExperienceCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TeacherExperienceCell: UITableViewCell {

    @IBOutlet var experienceLabel: UILabel!
    @IBOutlet var specExperienceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn (_ data: (String, String)){
        experienceLabel.text = data.0
        specExperienceLabel.text = data.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
