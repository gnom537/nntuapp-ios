//
//  NewsViewCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 19.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet var CardView: UIView!
    @IBOutlet var NewsImage: UIImageView!
    @IBOutlet var NewsHeadline: UILabel!
    
    var href: String?
    var imgHref: String?
    var Article: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CardView.clipsToBounds = true
        CardView.layer.cornerRadius = 14
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
