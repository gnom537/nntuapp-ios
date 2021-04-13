//
//  imageCellDBTT.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 25.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class imageCellDBTT: UITableViewCell {
    
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var roomImage: UIImageView!
    
    var imageData: UIImage?
    var roomName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn(){
        if (imageData != nil){
            roomImage.image = imageData
            roomLabel.text = roomName?.uppercased()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
