//
//  DBLessonCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 21.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class DBLessonCell: UITableViewCell {
    
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var stopTimeLabel: UILabel!
    @IBOutlet var upperInfoLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lowerInfoLabel: UILabel!
    
    @IBOutlet var mainDataStack: UIStackView!
    @IBOutlet var stickHeight: NSLayoutConstraint!
    
    var data : Lesson = emptyLesson()
    var rowIndex = 0
    
    public func updateView(){
        stickHeight.constant = mainDataStack.layer.bounds.height - 30
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
