//
//  AverageMarkCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 09.03.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class AverageMarkCell: UITableViewCell {
    
    @IBOutlet var semesterLabel: UILabel!
    @IBOutlet var MarkLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn(sem: Int, mark: Float){
        if (sem == -1){
            semesterLabel.text = "Средний балл"
        } else {
            semesterLabel.text = "\(sem) семестр"
        }
        if (mark.isNaN){
            MarkLabel.text = nil
        } else {
            MarkLabel.text = String(mark)
        }
    }
    
    func fillIn(name: String, mark: Int){
        MarkLabel.text = String(mark)
        semesterLabel.text = name
    }
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
