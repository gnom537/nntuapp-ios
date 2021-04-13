//
//  AverageMarkTableViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 09.03.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

func getAverage(marks: [Int]) -> Double {
    var sum: Double = 0
    for mark in marks {
        sum += Double(mark)
    }
    return sum/Double(marks.count)
}

class AverageMarkTableViewController: UITableViewController {
    
    var averageSems = [Float]()
    var diploma = [String: Int]()
    var averageOverall: Float = 0
    var diplomaKeys = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        diplomaKeys = Array(diploma.keys).sorted()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
//        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return diplomaKeys.count
        case 2:
            return averageSems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Общий"
        case 1:
            return "По дисциплинам"
        case 2:
            return "По семестрам"
        default:
            return nil
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "averageCell", for: indexPath) as! AverageMarkCell
        switch indexPath.section {
        case 0:
            cell.fillIn(sem: -1, mark: averageOverall)
        case 1:
            cell.fillIn(name: diplomaKeys[indexPath.row], mark: diploma[diplomaKeys[indexPath.row]] ?? 0)
        case 2:
            cell.fillIn(sem: indexPath.row+1, mark: averageSems[indexPath.row])
        default:
            cell.fillIn(name: "Произошла ошибка в заполнении", mark: 0)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
