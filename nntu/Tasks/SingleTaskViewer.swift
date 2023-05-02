//
//  SingleTaskViewer.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 30.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

final class SingleTaskViewer: UIViewController {
    private enum Constants {
        static let doneColor: UIColor = .systemBlue
        static let unDoneColor: UIColor = .systemRed
        static let titleColor: UIColor = .white
        static let doneButtonFont: UIFont = .systemFont(ofSize: 17, weight: .bold)
        static let doneText = "Выполнено"
        static let unDoneText = "Не выполнено"
        static let buttonAnimationDuration = 0.5
        static let buttonRadius: CGFloat = 7
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    var task: Task? {
        didSet {
           fillIn(task: task)
        }
    }
    var changeDone: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        fillIn(task: task)
        doneButton.layer.cornerRadius = Constants.buttonRadius
    }

    private func fillIn(task: Task?) {
        guard let task = task else { return }
        guard isViewLoaded else { return }
        titleLabel.text = task.title
        priorityLabel.text = "\(task.priority?.description ?? "средний") приоритет".uppercased()
        subjectLabel.text = task.subject
        descriptionLabel.text = task.description
        deadlineLabel.text = format(date: task.deadline)
        doneButton.setTitleColor(Constants.titleColor, for: .normal)
        doneButton.titleLabel?.font = Constants.doneButtonFont
        updateButtonState(done: task.done)
    }

    private func format(date: Date) -> String? {
        let df = DateFormatter()
        df.dateFormat = "d MMMM, HH:mm"
        return df.string(from: date)
    }

    private func updateButtonState(done: Bool) {
        guard let task = task else { return }
        let title = task.done ? Constants.doneText : Constants.unDoneText
        let color = task.done ? Constants.doneColor : Constants.unDoneColor
        doneButton.backgroundColor = color
        doneButton.setTitle(title, for: .normal)
    }

    @IBAction func switchDone(_ sender: UIButton) {
        guard let task = task else { return }
        let done = !task.done
        updateButtonState(done: done)
        changeDone?(done)
        self.task?.done = done
    }
}
