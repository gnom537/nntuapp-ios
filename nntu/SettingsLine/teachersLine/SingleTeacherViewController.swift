//
//  SingleTeacherViewController.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class SingleTeacherViewController: UITableViewController {
    
    var data : teacher?
    var pairs = [(String, String)]()
    var contacts = [(String, String)]()
    var nameNposition = (String(), String())
    var experience : (String, String)? = nil
    var experienceLength : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    public func fillData(_ input: teacher) {
        data = input
        pairs = getPairs(input)
        contacts = getContacts(input)
        nameNposition = getNameNPosition(input)
        experience = getExperience(input)
        experienceLength = experience == nil ? 0 : 1
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if data != nil {
            return 1 + experienceLength + pairs.count + contacts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "npCell", for: indexPath) as! TeacherNameNPositionCell
            cell.fillIn(nameNposition)
            return cell
        } else if (indexPath.row == 1 && pairs.count != 0){
            if (experience != nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "expCell", for: indexPath) as! TeacherExperienceCell
                cell.fillIn(experience!)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath) as! TeacherDataPairCell
            cell.fillIn(pairs[indexPath.row - 1])
            return cell
        } else if (indexPath.row >= pairs.count + experienceLength + 1 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! TeacherContactsCell
            cell.fillIn(contacts[indexPath.row - pairs.count - experienceLength - 1])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pairCell", for: indexPath) as! TeacherDataPairCell
            cell.fillIn(pairs[indexPath.row - experienceLength - 1])
            return cell
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
