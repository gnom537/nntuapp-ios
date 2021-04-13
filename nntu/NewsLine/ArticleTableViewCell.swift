//
//  ArticleTableViewCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 19.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet var Headline: UILabel!
    @IBOutlet var ArticleImage: UIImageView!
    @IBOutlet var TheArticle: UILabel!

    @IBOutlet var ImageHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
         
         let imageHeight = ArticleImage.image?.size.height ?? 3
         let imageWidth = ArticleImage.image?.size.width ?? 4
         let proportion = imageHeight/imageWidth
         ImageHeight.constant = proportion * (UIScreen.main.bounds.width - 20)
         */
        ArticleImage.layer.cornerRadius = 7
        ArticleImage.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
