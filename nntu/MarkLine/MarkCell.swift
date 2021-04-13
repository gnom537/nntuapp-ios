//
//  MarkCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 05.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class MarkCell: UITableViewCell {

    @IBOutlet var DisName: UILabel!
    @IBOutlet var typeName: UILabel!
    @IBOutlet var result: UILabel!
    @IBOutlet var MarkStack: UIStackView!
    
    
    var FirstKn, SecondKn, PropFirstKn, PropSecondKn, Result : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screen = UIScreen.main
//        if screen.bounds.width < 350 {
//            DisName.font = UIFont.systemFont(ofSize: 14)
//        }
        MarkStack.isHidden = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
