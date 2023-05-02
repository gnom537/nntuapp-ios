//
//  SubjectSuggestionCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

class SubjectSuggestionCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 7
    }
}
