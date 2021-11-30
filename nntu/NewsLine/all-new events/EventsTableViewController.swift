//
//  EventsTableViewController.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 06.08.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    var eventsArray = [event]()
    var loadedImages = [UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetBadge()
    }
    
    @objc func refresh(){
        loadEvents({events in
            self.eventsArray = events
            self.loadedImages = [UIImage?](repeating: nil, count: self.eventsArray.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            loadOldArticlesAsEvents({ nntuArticles in
                self.eventsArray += nntuArticles
                self.loadedImages += [UIImage?](repeating: nil, count: nntuArticles.count)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                    if (self.eventsArray.count == 0){
                        self.internetAlert()
                    }
                    self.resetBadge()
                }
            })
        })
    }
    
    func internetAlert(){
        let alert = UIAlertController(title: "Новости не были загружены", message: "Проверьте подключение к интернету", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventsArray.count == 0 ? 1 : eventsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (eventsArray.count == 0){
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "eventsLoadingCell", for: indexPath)
            return loadingCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        
//        cell.setColor(eventsArray[indexPath.row].color)
        cell.setColor(cell.data?.color)
        
        if indexPath.row == 0 {
            print("hihi")
        }
        
        if loadedImages[indexPath.row] == nil {
            cell.previewImage.image = UIImage.init(named: "logoPlaceholder")
        }
        
        cell.fillIn(eventsArray[indexPath.row], image: loadedImages[indexPath.row], callback: { image in
            self.loadedImages[indexPath.row] = image
        })

        // Configure the cell...

        return cell
    }
    
    func resetBadge(){
        if let eventTab = self.tabBarController?.tabBar.items?[0]{
            eventTab.badgeValue = nil
        }
        DispatchQueue.global().async {
            if let id = getLastID() {
                saveID(id)
            } else if let id = localID {
                saveID(id)
            }
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
        let dest = segue.destination as! SingleEventViewController
        let cell = sender as! EventTableViewCell
        dest.data = cell.data
        dest.image = cell.previewImage.image
        dest.fillCellArray()
    }
    
    

}

//MARK: - extension


func getImageData(from url: URL, completion: @escaping (UIImage?) -> ()) {
   URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
    guard let data = data, error == nil else {
       return
    }
    completion(UIImage(data: data))
   }).resume()
}


extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red}
    var greenValue: CGFloat{ return CIColor(color: self).green}
    var blueValue: CGFloat{ return CIColor(color: self).blue}
    var alphaValue: CGFloat{ return CIColor(color: self).alpha}
    func isDark() -> Bool {
        let ci = CIColor(color: self)
        
        let red = CGFloat(ci.red)
        let green = CGFloat(ci.green)
        let blue = CGFloat(ci.blue)
        
        let brightness = (red*299 + green*587 + blue*114)/1000
        return brightness < 0.5
    }
}
