//
//  Checkmark.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 27.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

final class Checkmark: UIButton {
    private enum Constants {
        static let notChecked: UIImage = .init(systemName: "circle")!
        static let checked: UIImage = .init(systemName: "checkmark.circle.fill")!
    }

    var isChecked = false {
        didSet {
            let image = isChecked ? Constants.checked : Constants.notChecked
            setImage(image, for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setImage(Constants.notChecked, for: .normal)
    }
}
