//
//  MoreRoomsTableViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 05.08.2020.
//  Copyright © 2020 Алексей Шерстнев. All rights reserved.
//

import UIKit

//struct room {
//    let name : String
//    let number : String
//}
//
//class building {
//    var rooms = [room]()
//    func addRoom(_ name: String, _ number: String){
//        rooms.append(room(name: name, number: number))
//    }
//}

class MoreRoomsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var SearchTextField: UITextField!
    @IBOutlet var BuildingSegment: UISegmentedControl!
    @IBOutlet var BuildingStack: UIStackView!
    
    var controllerData = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let parentController = ControllerToUpdate as! NavigationViewController
        BuildingSegment.selectedSegmentIndex = parentController.choosingBuilding.selectedSegmentIndex
        
        let config = UIImage.SymbolConfiguration(textStyle: .body)
        let glassImage = UIImageView()
        glassImage.bounds = view.frame.insetBy(dx: -20,dy: 0)
        glassImage.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        SearchTextField.leftView = glassImage
        SearchTextField.leftViewMode = .always
        SearchTextField.delegate = self
        
        reloadDataWithSegment()
//        checkRooms()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //MARK: numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return controllerData.count
    }

    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return controllerData[section].count
    }
    
    //MARK: titleForHeaderInSection
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(controllerData[section][controllerData[section].keys.first!]!.first!) корпус"
    }

    
    //MARK:  cellForRow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as? RoomCell else {
            fatalError()
        }
        cell.roomName.text = Array(controllerData[indexPath.section].keys)[indexPath.row]
        // Configure the cell...
        return cell
    }
    
    //MARK:  didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PreLoadedRoom = self.controllerData[indexPath.section][Array(controllerData[indexPath.section].keys)[indexPath.row]]
        ControllerToUpdate?.viewDidAppear(true)
        self.dismiss(animated: true, completion: {
        })
    }
    
    //MARK: reloadDataWithSegment
    func reloadDataWithSegment(){
        controllerData = [everyBuilding[BuildingSegment.selectedSegmentIndex]]
        self.tableView.reloadData()
    }
    
    //MARK: SegmentChanged
    @IBAction func SegmentChanged(_ sender: Any) {
        reloadDataWithSegment()
    }
    
    //MARK: SearchStarted
    @IBAction func SearchStarted(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.BuildingStack.isHidden = true
        })
        UIView.animate(withDuration: 0.15, animations: {
            self.BuildingStack.alpha = 0
        })
    }
    
    
    //MARK: TapHappened
    @IBAction func TapHappened(_ sender: Any) {
        SearchTextField.endEditing(true)
    }
    
    
    //MARK: SearchEnded
    @IBAction func SearchEnded(_ sender: Any) {
        UIView.animate(withDuration: 0.15, animations: {
            self.BuildingStack.isHidden = false
        })
        UIView.animate(withDuration: 0.4, animations: {
            self.BuildingStack.alpha = 1
        })
    }
    
    
    //MARK: textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchTextField.endEditing(true)
        return false
    }
    
    
    
    //MARK: SearchWhileTyping
    @IBAction func SearchWhileTyping(_ sender: Any) {
        controllerData = [everyBuilding[BuildingSegment.selectedSegmentIndex]]
        if (SearchTextField.text != "" && SearchTextField.text != nil){
            controllerData = search(data: everyBuilding, searchWord: SearchTextField.text ?? "")
        }
//        keys = Array(controllerData.keys).sorted()
        self.tableView.reloadData()
    }
    
    

    //MARK: - search()
    func search(data: [[String: String]], searchWord: String) -> [[String: String]] {
        var output = [[String: String]]()
        for building in data {
            var buildingDict = [String: String]()
            for key in building.keys {
                if String(key).capitalize().contains(searchWord.capitalize()){
                    buildingDict[key] = building[key]
                }
            }
            if (!buildingDict.isEmpty){
                output.append(buildingDict)
            }
        }
        return output
    }
}
