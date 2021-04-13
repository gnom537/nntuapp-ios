//
//  singleLessonViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 25.01.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class singleLessonViewController: UITableViewController {
    
    var lesson : Lesson = emptyLesson()
    var howManyCells = 1
    var rooms = [String]()
    var images = [UIImage]()
    @IBOutlet var navbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.backButtonTitle = lesson.name
        if (lesson.rooms.count == 0){return}
        for i in (0 ... lesson.rooms.count - 1){
            let image = UIImage(named: lesson.rooms[i].replacingOccurrences(of: " ", with: ""))
            if (image != nil && lesson.rooms[i].count > 2){
                howManyCells += 1
                rooms.append(lesson.rooms[i].replacingOccurrences(of: " ", with: ""))
                images.append(image!)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return howManyCells
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "LDataCell", for: indexPath) as! LessonDataDBTTCell
            cell.data = lesson
            cell.fillIn()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCellwithName", for: indexPath) as! imageCellDBTT
            cell.roomName = rooms[indexPath.row - 1]
            cell.imageData = images[indexPath.row - 1]
            cell.fillIn()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! imageCellDBTT
        let navVC = segue.destination as! NavigationViewController
        navVC.preloadedRoom = cell.roomName ?? ""
    }
    

}
