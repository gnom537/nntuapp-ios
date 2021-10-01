//
//  TeacherSearchViewController.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class TeacherSearchViewController: UITableViewController {
    
    var allTeachers = Set<teacher>()
    var teacherArray = [teacher]()
    var foundTeachers = [teacher]()
    var searching = false
    var loading = true
    
    @IBOutlet var theSearchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theSearchBar.delegate = self
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.allTeachers = loadTeachers()

            DispatchQueue.main.async {
                self.loading = false
                self.teacherArray = getTeachersForTableView(self.allTeachers)
                if (self.allTeachers.count == 0){
                    self.showTeacherConnectionAlert()
                }
                self.tableView.reloadData()
            }
        }

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func showTeacherConnectionAlert(){
        let alert = UIAlertController(title: "Данные не были загружены", message: "Проверьте подключение к интернету. Если с интернетом всё хорошо, свяжитесь с разработчиком", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchForTeacher(_ input: String){
        foundTeachers = allTeachers.findTeacher(input)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if loading {return 1}
        return searching ? foundTeachers.count : teacherArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as! TeacherCell
        cell.textLabel?.text = searching ? foundTeachers[indexPath.row].name : teacherArray[indexPath.row].name
        cell.data = searching ? foundTeachers[indexPath.row] : teacherArray[indexPath.row]
        return cell
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        let cell = sender as! TeacherCell
        let child = segue.destination as! SingleTeacherViewController
        child.fillData(cell.data!)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension TeacherSearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = !searchText.isEmpty
        searchForTeacher(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
