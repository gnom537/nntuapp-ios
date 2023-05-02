//
//  TaskListController.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 25.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TaskListController: UITableViewController {
    private enum Constants {
        static let cellID = "TaskCell"
        static let unableToDelete: (title: String, message: String) = ("Не удаётся удалить задачу", "Проверьте соединение")
    }
    private let provider: TaskProvider
    private let storage: TaskStorage
    private var nothingFoundStack = NothingFoundStack(
        emoji: "✅",
        title: "Задач пока нет",
        description: "Можете добавить задачу, нажав на +"
    )
    private var tasks: [Task] {
        didSet {
            storage.tasks = tasks
            sortByDay()
            tableView.reloadData()
        }
    }
    private var sortedByDay = [Int: [Task]]()
    private var keys = [Int]()

    @IBOutlet var ptr: UIRefreshControl!

    required init?(coder: NSCoder) {
        self.provider = TaskProvider()
        self.storage = TaskStorage()
        self.tasks = self.storage.tasks
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sortByDay()
        tableView.reloadData()
        onlineTasks()
        view.addSubview(nothingFoundStack)
        applyConstraints()
        ptr.addTarget(self, action: #selector(onlineTasks), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBadge(self)
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            nothingFoundStack.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            nothingFoundStack.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    private func nothingFound(_ shouldShow: Bool){
        nothingFoundStack.isHidden = !shouldShow
    }

    private var group: String {
        return UserDefaults.standard.string(forKey: "Group") ?? ""
    }

    @objc func onlineTasks() {
        provider.get(group: group, local: tasks) { [weak self] result in
            assert(Thread.isMainThread)
            guard let self = self else { return }
            switch result {
            case let .success(combined):
                self.tasks = combined
            case let .failure(error):
                print(error.localizedDescription)
            }
            self.ptr.endRefreshing()
        }
    }

    private func sortByDay() {
        sortedByDay = [:]
        for task in tasks.sorted() {
            let dayInEra = task.deadline.dayInEra
            sortedByDay[dayInEra, default: []].append(task)
        }
        keys = sortedByDay.keys.sorted()
    }

    private func deleteTask(id: Int) {
        provider.delete(id: id) { [weak self] result in
            guard let self = self else { return }
            assert(Thread.isMainThread)
            switch result {
            case .success:
                guard let index = self.tasks.firstIndex(where: {$0.id == id}) else { return }
                self.tasks.remove(at: index)
            case let .failure(error):
                let alert = AlertFactory.shared.makePrompt(title: Constants.unableToDelete.title, message: Constants.unableToDelete.message)
                self.present(alert, animated: true)
                self.onlineTasks()
                print(error.localizedDescription)
            }
        }
    }

    func insert(task: Task?) {
        guard let task = task else { return }
        tasks.append(task)
        sortByDay()
        tableView.reloadData()
        onlineTasks()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        nothingFound(keys.count == 0)
        return keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keys[section]
        return sortedByDay[key]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        guard let taskCell = cell as? TaskCell else { return cell }
        let key = keys[indexPath.section]
        let task = sortedByDay[key]![indexPath.row]
        taskCell.fillIn(from: task) { [weak self] done in
            guard let self = self else { return }
            guard let index = self.tasks.firstIndex(where: {$0.id == task.id}) else { return }
            self.tasks[index].done = done
        }
        return taskCell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = keys[section]
        guard let data = sortedByDay[key], !data.isEmpty else { return nil }
        return data[0].deadline.shortString.uppercased()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alert = UIAlertController(
                title: "Вы уверены?",
                message: "Задача удалится у всех ваших одногруппников",
                preferredStyle: .alert
            )
            let yes = UIAlertAction(title: "Да, удалить", style: .destructive, handler: { [unowned self] _ in
                let key = keys[indexPath.section]
                let id = sortedByDay[key]![indexPath.row].id
                sortedByDay[key]!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                deleteTask(id: id)
            })
            let no = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    @IBAction func showInfo(_ sender: UIBarButtonItem) {
        let alert = AlertFactory.shared.makePrompt(
            title: NSLocalizedString("Задачи название", comment: ""),
            message: NSLocalizedString("Задачи описание", comment: ""),
            buttonText: nil
        )
        present(alert, animated: true)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskCell = sender as? TaskCell else { return }
        guard let taskID = taskCell.task?.id else {return}
        guard let index = tasks.firstIndex(where: {$0.id == taskID}) else {return}
        guard let singleViewer = segue.destination as? SingleTaskViewer else { return }
        singleViewer.task = taskCell.task
        singleViewer.changeDone = { [weak self] done in
            guard let self = self else { return }
            self.tasks[index].done = done
        }
    }
}
