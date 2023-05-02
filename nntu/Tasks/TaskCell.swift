//
//  TaskCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 25.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var checkmark: Checkmark!
    private var doneClosure: ((Bool) -> Void)?

    var task: Task? {
        didSet {
            guard let task = task else { return }
            title.text = task.title
            subtitle.text = task.subject
            checkmark.isChecked = task.done
            checkmark.addTarget(self, action: #selector(check), for: .touchUpInside)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillIn(from task: Task, closure: @escaping (Bool) -> Void) {
        self.task = task
        doneClosure = closure
    }

    @objc private func check() {
        checkmark.isChecked = !checkmark.isChecked
        doneClosure?(checkmark.isChecked)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
