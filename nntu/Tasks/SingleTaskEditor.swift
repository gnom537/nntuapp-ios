//
//  SingleTaskEditor.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 28.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

final class SingleTaskEditor: UIViewController {
    private enum Constants {
        static let suggestionCellID = "SuggestionCell"
        static let suggestionFont: UIFont = UIFont.systemFont(ofSize: 17)
        static let suggestionPadding: CGFloat = 5
        static let wrongMessage: (title: String, message: String) = ("Не все данные введены", "Укажите название задачи")
        static let noConnection: (title: String, message: String) = ("Не удалось загрузить задачу", "Проверьте соединение")
    }

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextField!
    @IBOutlet var subjectField: UITextField!
    @IBOutlet var suggestionCollectionView: UICollectionView!
    @IBOutlet var prioritySegments: UISegmentedControl!
    @IBOutlet var deadlinePicker: UIDatePicker!

    private var provider = TaskProvider()

    private var task: Task? {
        guard let title = titleField.text else {return nil}
        return Task(
            id: 0, // may be replaced
            title: title,
            description: descField.text,
            subject: subjectField.text,
            priority: Priority(rawValue: prioritySegments.selectedSegmentIndex + 1),
            deadline: deadlinePicker.date,
            done: false
        )
    }

    private lazy var ttForSuggestions = CoreDataStack.shared.fetchLessons()
    private var suggestions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        scrollView.keyboardDismissMode = .onDrag
        subjectField.addTarget(self, action: #selector(subjectChanged(_:)), for: .editingChanged)
        suggestionCollectionView.dataSource = self
        suggestionCollectionView.delegate = self
        titleField.becomeFirstResponder()
    }

    func configureNavBar() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navBar.topItem?.rightBarButtonItem = doneItem
        navBar.topItem?.leftBarButtonItem = cancelItem
    }

    func configureFields() {
        titleField.delegate = self
        descField.delegate = self
        subjectField.delegate = self
    }

    @objc private func done() {
        guard let task = task else {
            let alert = AlertFactory.shared.makePrompt(title: Constants.wrongMessage.title, message: Constants.wrongMessage.message)
            self.present(alert, animated: true)
            return
        }
        let group = UserDefaults.standard.string(forKey: "Group") ?? ""
        provider.upload(task: task, group: group) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let tabBar = self.presentingViewController as? UITabBarController
                    let taskNavigation = tabBar?.viewControllers?[3] as? UINavigationController
                    let taskTab = taskNavigation?.viewControllers[0] as? TaskListController
                    self.dismiss(animated: true, completion: {
                        taskTab?.insert(task: self.task)
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                    let alert = AlertFactory.shared.makePrompt(title: Constants.noConnection.title, message: Constants.noConnection.message)
                    self.present(alert, animated: true)
                }
            }
        }
    }

    @objc private func cancel() {
        self.dismiss(animated: true)
    }

    @objc private func updateSubjectSuggestions(keyword: String?) {
        guard let keyword = keyword, !keyword.isEmpty else {
            suggestions = []
            return
        }
        let containing: [String] = ttForSuggestions.compactMap { lesson in
            guard lesson.name != keyword else {return nil}
            guard lesson.name.uppercased().contains(keyword.uppercased()) else {return nil}
            return lesson.name
        }
        suggestions = Array(Set(containing))
    }

    @objc private func subjectChanged(_ sender: UITextField) {
        updateSubjectSuggestions(keyword: sender.text)
        suggestionCollectionView.isHidden = suggestions.isEmpty
        suggestionCollectionView.reloadData()
    }

    private func getTextWidth(_ s: String?) -> CGFloat {
        guard let s = s else { return 0 }
        let font = Constants.suggestionFont
        let attributes = [NSAttributedString.Key.font: font]
        let size = NSString(string: s).size(withAttributes: attributes)
        return size.width
    }
}

extension SingleTaskEditor: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleField: descField.becomeFirstResponder()
        case descField: subjectField.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return false
    }
}

extension SingleTaskEditor: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        suggestions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.suggestionCellID, for: indexPath)
        guard let suggestionCell = cell as? SubjectSuggestionCell else { return cell }
        suggestionCell.label.font = Constants.suggestionFont
        suggestionCell.label.text = suggestions[indexPath.row]
        return suggestionCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = getTextWidth(suggestions[indexPath.row]) + Constants.suggestionPadding * 2
        return CGSize(width: width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        subjectField.text = suggestions[indexPath.row]
        collectionView.isHidden = true
    }
}
