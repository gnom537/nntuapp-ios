//
//  SingleEventViewController.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 07.08.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class SingleEventViewController: UITableViewController, EKEventViewDelegate {
    
    var data: event?
    var image: UIImage?
    var whichCellToShow = [Int]()
    var lastNonLinkIndex = 0
    
    let titleID = 0
    let imageID = 1
    let descID = 2
    let calID = 3
    let placeID = 4
    let linkID = 5  

    override func viewDidLoad() {
        super.viewDidLoad()
        if (data?.author == "Новости НГТУ"){
            if let url = URL(string: self.data!.description){
                self.data!.description = "Загрузка новости..."
                safelyGetArticle(url: url, completition: { desc in
                    self.data!.description = desc != "" ? desc : "Не удалось загрузить новость. Вы можете перейти по ссылке и посмотреть её на сайте."
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    public func fillCellArray(){
        if let data = data {
            whichCellToShow = [0]
            if data.imageLink != nil {whichCellToShow.append(1)}
            whichCellToShow.append(2)
            if data.startTime != nil && data.stopTime != nil {whichCellToShow.append(3)}
            if data.place != nil {whichCellToShow.append(4)}
            lastNonLinkIndex = whichCellToShow.count
            for _ in data.links{
                whichCellToShow.append(5)
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data != nil ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whichCellToShow.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch whichCellToShow[indexPath.row] {
        case titleID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventTitleCell", for: indexPath) as! eventTitleCell
            cell.fillIn(data!)
            return cell
        case imageID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventImageCell", for: indexPath) as! eventImageCell
            cell.fillIn(data: data!, image: image!)
            return cell
        case descID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventDescriptionCell", for: indexPath) as! eventDescriptionCell
            cell.fillIn(data!)
            return cell
        case calID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addToCalendarCell", for: indexPath) as! addToCalendarCell
            cell.fillIn(data!)
            return cell
        case placeID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventPlaceCell", for: indexPath) as! eventPlaceCell
            cell.fillIn(data!)
            return cell
        case linkID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventLinkCell", for: indexPath) as! eventLinkCell
            cell.fillIn(link: data!.links[indexPath.row - lastNonLinkIndex], color: data!.color)
            return cell
        default:
            print("fuck")
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventTitleCell", for: indexPath)
            return cell
        }
    }
    
    @IBAction func openRoom(_ sender: UIButton) {
        if (UIImage(named: data?.place ?? "") != nil){
            let segueID = "openEventRoom"
            self.performSegue(withIdentifier: segueID, sender: self)
        }
    }
    
    @IBAction func addInCalendar(_ sender: UIButton){
        self.data?.showInCalendar(completition: { result in
            if let eventController = result {
                eventController.delegate = self
                let navigationController = UINavigationController(rootViewController: eventController)
                self.present(navigationController, animated: true, completion: nil)
            } else {
                self.calendarAlert()
            }
        })
    }
    
    func calendarAlert(){
        let alert = UIAlertController(title: "Не удалось добавить событие в календарь", message: "Проверьте, есть ли доступ у приложения к календарю", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
        let dest = segue.destination as! NavigationViewController
        dest.preloadedRoom = self.data?.place ?? ""
    }
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
