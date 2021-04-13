//
//  FirstViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 16.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

/*
 //MARK: rotateImage
 extension UIImage {
     func rotate(radians: Float) -> UIImage? {
         var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
         // Trim off the extremely small float value to prevent core graphics from rounding it up
         newSize.width = floor(newSize.width)
         newSize.height = floor(newSize.height)

         UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
         let context = UIGraphicsGetCurrentContext()!

         // Move origin to middle
         context.translateBy(x: newSize.width/2, y: newSize.height/2)
         // Rotate around middle
         context.rotate(by: CGFloat(radians))
         // Draw the image at its center
         self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return newImage
     }
 }
 */



class NavigationViewController: UIViewController, UIScrollViewDelegate {
    
    var minFloor : Int = 0
    var maxFloor : Int = 0
    
    @IBOutlet var InputTextField: UITextField!
    @IBOutlet var FindButton: UIButton!
    @IBOutlet var TheImage: UIImageView!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var choosingfloor: UISegmentedControl!
    @IBOutlet var FloorBuilding: UISegmentedControl!
    @IBOutlet var choosingBuilding: UISegmentedControl!
    @IBOutlet var ImageWidth: NSLayoutConstraint!
    
    @IBOutlet var moreButtonsView : UIView!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    var preloadedRoom = String()
    var rotated = false

    
    //MARK: - viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        FindButton.layer.cornerRadius = 7
        InputTextField.layer.cornerRadius = FindButton.layer.cornerRadius
        scroll.delegate = self
        let screen : CGRect = self.view.bounds
        ImageWidth.constant = screen.width
        choosingfloor.selectedSegmentIndex = 1
        choosingBuilding.selectedSegmentIndex = 5
        buildingFloorLogic()
        //showemptyfloors()
        TheImage.image = UIImage(named: "1level non-active 6")
        
        
        Entered = UserDefaults.standard.bool(forKey: "Entered")
        let Nstud = UserDefaults.standard.string(forKey: "Nstud")
        
        moreButtonsView.clipsToBounds = true
        moreButtonsView.layer.cornerRadius = 20
        if (preloadedRoom == ""){
            TabBar = self.tabBarController?.viewControllers
        }
        
        if (Entered == false){
            if (preloadedRoom == ""){
                self.tabBarController?.viewControllers?.remove(at: 1)
            }
//            self.tabBarController?.viewControllers?.remove(at: 2)
        } else {
            self.tabBarController?.viewControllers = TabBar
            if (Nstud == ""){
                self.tabBarController?.viewControllers?.remove(at: 1)
            }
        }
        
        
        if preloadedRoom != "" {
            InputTextField.text = preloadedRoom
            topConstraint.constant = 20
            findbutton()
        }
        /*
         let screen: CGRect = self.view.bounds
         if (screen.height >= 768){
             ImageHeight.constant = screen.height - 250
         }
         */
    }
    
    //MARK: checksegment()
    
    //MARK: showemptyfloors()
    func showemptyfloors(){
        let nowsegmentbuilding = Int(choosingBuilding.titleForSegment(at: choosingBuilding.selectedSegmentIndex)!) ?? 6
        let nowsegmentfloor = Int(choosingfloor.titleForSegment(at: choosingfloor.selectedSegmentIndex)!) ?? 0
        TheImage.image = UIImage(named: "\(nowsegmentfloor)level non-active \(nowsegmentbuilding)")
        print("\(nowsegmentfloor)level non-active \(nowsegmentbuilding)")
    }

    //MARK: - Find button
    
    func findbutton(){ //достал её из кнопки для того, чтобы потом её вызвать при тапе в свободное место
        InputTextField.endEditing(true)
        InputTextField.placeholder = NSLocalizedString("Введите аудиторию..", comment: "")
        let input = Int(InputTextField.text ?? "0") ?? 0
        if (input < 1000 || input > 8000) {choosingfloor.selectedSegmentIndex = 1
            InputTextField.text = ""
            InputTextField.placeholder = NSLocalizedString("Ошибка", comment: "")
            showemptyfloors()
        } else {
            choosingBuilding.selectedSegmentIndex = (input/1000)-1
            buildingFloorLogic()
            
            if (choosingfloor.titleForSegment(at: 0) == "1"){
                choosingfloor.selectedSegmentIndex = (input/100)%10 - 1
            } else {
                choosingfloor.selectedSegmentIndex = (input/100)%10
            }
            
            if (input >= 6103 && input <= 6110){
                choosingfloor.selectedSegmentIndex = 0
            }
            
            TheImage.image = UIImage(named: "\(input)")
            if (UIImage(named: "\(input)") == nil){
                InputTextField.text = ""
                InputTextField.placeholder = NSLocalizedString("Аудитория не найдена", comment: "")
                buildingFloorLogic()
                showemptyfloors()
            }
        }
    }
    
    
    //MARK: - buildingFloorLogic()
    func buildingFloorLogic(){
        switch choosingBuilding.selectedSegmentIndex {
        case 0:
            maxFloor = 3
            minFloor = 1
        case 1:
            maxFloor = 3
            minFloor = 1
        case 2:
            maxFloor = 3
            minFloor = 1
        case 3:
            maxFloor = 4
            minFloor = 1
        case 4:
            maxFloor = 4
            minFloor = 1
        case 5:
            maxFloor = 5
            minFloor = 0
        default:
            maxFloor = 1
            minFloor = 1
        }
        
        if (choosingfloor.titleForSegment(at: 0) == "1"){
            choosingfloor.selectedSegmentIndex = 0
        } else {choosingfloor.selectedSegmentIndex = 1}
        
        
        while (choosingfloor.titleForSegment(at: 0) != String(minFloor)){
            let nowMin = Int(choosingfloor.titleForSegment(at: 0)!)!
            if (minFloor < nowMin){
                choosingfloor.insertSegment(withTitle: String(nowMin - 1), at: 0, animated: true)
            } else {
                if (choosingfloor.selectedSegmentIndex == 0){
                    choosingfloor.selectedSegmentIndex = 1
                }
                choosingfloor.removeSegment(at: 0, animated: true)
            }
        }
        
        while (choosingfloor.titleForSegment(at: choosingfloor.numberOfSegments - 1) != String(maxFloor)){
            let maxIndex = choosingfloor.numberOfSegments - 1
            let nowMax = Int(choosingfloor.titleForSegment(at: maxIndex)!)!
            if (maxFloor > nowMax){
                choosingfloor.insertSegment(withTitle: String(nowMax + 1), at: maxIndex + 1, animated: true)
            } else {
                choosingfloor.removeSegment(at: maxIndex, animated: true)
            }
        }
    }
    
    @IBAction func FindButtonActivated(_ sender: Any) {
        findbutton()
    }
    
    @IBAction func FloorOrBuildingChanged(_ sender: UISegmentedControl) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        if (sender.selectedSegmentIndex == 0){
            choosingBuilding.isHidden = true
            choosingfloor.isHidden = false
        }
        else if (sender.selectedSegmentIndex == 1){
            choosingBuilding.isHidden = false
            choosingfloor.isHidden = true
        }
    }
    
    
    
    //MARK: - Floor Segment Changed
    @IBAction func FloorSegmentChanged(_ sender: Any) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        InputTextField.placeholder = NSLocalizedString("Введите аудиторию..", comment: "")
        let input: Int = Int(InputTextField.text ?? "0") ?? 0
        let nowsegment = Int(choosingfloor.titleForSegment(at: choosingfloor.selectedSegmentIndex)!) ?? 0
//        print(nowsegment)
        let buildingsegment = Int(choosingBuilding.titleForSegment(at: choosingBuilding.selectedSegmentIndex)!) ?? 6
        var requestedSegment = (input/100)%10
        let requestedBuilding = (input/1000)
        
        if (input >= 6103 && input <= 6110){
            requestedSegment = 0
        }
        
        if (input != 0){
            if (nowsegment == requestedSegment && requestedBuilding == buildingsegment){
                TheImage.image = UIImage(named: "\(input)")
            } else {
                if (requestedBuilding == buildingsegment){
                    switch buildingsegment {
                    case 1:
                        if (nowsegment < requestedSegment){
                            TheImage.image = UIImage(named: "\(nowsegment)level up \(buildingsegment)")
                        } else {
                            showemptyfloors()
                        }
                    case 2:
                        if (nowsegment < requestedSegment){
                             TheImage.image = UIImage(named: "\(nowsegment)level up \(buildingsegment)")
                        } else if (nowsegment == 2 && requestedSegment == 1){
                             TheImage.image = UIImage(named: "\(nowsegment)level down \(buildingsegment)")
                        } else {
                            showemptyfloors()
                        }
                    case 3:
                        if (nowsegment < requestedSegment){
                            TheImage.image = UIImage(named: "\(nowsegment)level up \(buildingsegment)")
                        }
                        else {
                            showemptyfloors()
                        }
                    case 4:
                        if (((input > 4400 && input < 4410) || (input > 4303 && input < 4313)) && (nowsegment < requestedSegment)) {
                            TheImage.image = UIImage(named: "\(nowsegment)level up sec \(buildingsegment)")
                        } else if (nowsegment < requestedSegment){
                            TheImage.image = UIImage(named: "\(nowsegment)level up \(buildingsegment)")
                        } else {
                            showemptyfloors()
                        }
                    case 5:
                        if (((requestedSegment == 2 && nowsegment == 1) || (input == 5301 || input == 5302) || (input == 5401 || input == 5402)) && nowsegment < requestedSegment){
                            TheImage.image = UIImage(named: "\(nowsegment)level up sec \(buildingsegment)")
                        } else if (nowsegment > 0 && nowsegment < requestedSegment){
                            TheImage.image = UIImage(named: "\(nowsegment)level up \(buildingsegment)")
                        } else {
                            showemptyfloors()
                        }
                    case 6:
                        if (nowsegment > 1 && nowsegment < requestedSegment){
                            TheImage.image = UIImage(named: "\(nowsegment)level up \(buildingsegment)")
                        }
                        else if (nowsegment > requestedSegment && requestedSegment != 0) {
                            showemptyfloors()
                        }
                        else if (nowsegment == 1){
                            if (input == 6243){
                                TheImage.image = UIImage(named: "1level up 6243 \(buildingsegment)")
                            }
                            else if (input == 6244){
                                TheImage.image = UIImage(named: "1level up 6244 \(buildingsegment)")
                            }
                            else if (input == 6245 || input == 6246){
                                TheImage.image = UIImage(named: "1level up B3 \(buildingsegment)")
                            }
                            else if (input >= 6247 && input <= 6257){
                                TheImage.image = UIImage(named: "1level up B4 \(buildingsegment)")
                            }
                            else if (input == 6258 || input == 6259){
                                TheImage.image = UIImage(named: "1level up B5 \(buildingsegment)")
                            }
                            else if (input >= 6260 && input <= 6269){
                                TheImage.image = UIImage(named: "1level up B6 \(buildingsegment)")
                            }
                            else if (input == 6270){
                                TheImage.image = UIImage(named: "1level up B7 \(buildingsegment)")
                            }
                            else if (input == 6020){
                                TheImage.image = UIImage(named: "1level down 6020 \(buildingsegment)")
                            }
                            else if (input >= 6103 && input <= 6110){
                                TheImage.image = UIImage(named: "1level down B3 \(buildingsegment)")
                            }
                            else if (input >= 6022 && input <= 6043){
                                TheImage.image = UIImage(named: "1level down B4 B6 \(buildingsegment)")
                            }
                            else {TheImage.image = UIImage(named: "1level up \(buildingsegment)")}
                        }
                        else if (requestedSegment == 0 && nowsegment > 1){
                            showemptyfloors()
                        }
                    default:
                        showemptyfloors()
                    }
                    
                } else {
                    showemptyfloors()
                }
            }
        } else {showemptyfloors()}
    }
    
    @IBAction func BuildingSegmentChanged(_ sender: Any) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        buildingFloorLogic()
        let input: Int = Int(InputTextField.text ?? "0") ?? 0
        let nowsegment = Int(choosingfloor.titleForSegment(at: choosingfloor.selectedSegmentIndex)!) ?? 0
        let buildingsegment = Int(choosingBuilding.titleForSegment(at: choosingBuilding.selectedSegmentIndex)!) ?? 6
        let requestedSegment = (input/100)%10
        let requestedBuilding = (input/1000)
        if (nowsegment == requestedSegment && requestedBuilding == buildingsegment){
            TheImage.image = UIImage(named: "\(input)")
        } else {
            showemptyfloors()
        }
    }
    
    //MARK: TapHappened()
    @IBAction func TapHappened(_ sender: Any) {
        InputTextField.endEditing(true)
        if (InputTextField.text != "" ){
            findbutton()
        } else {
            showemptyfloors()
        }
    }
    
    //MARK: viewForZooming()
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return TheImage
    }
    
    //MARK: - viewDidAppear()
    override func viewDidAppear(_ animated: Bool){
        if (PreLoadedRoom != nil){
            InputTextField.text = PreLoadedRoom
            PreLoadedRoom = nil
            findbutton()
            ControllerToUpdate = nil
        }
    }
    
    @IBAction func moreButton(){
        ControllerToUpdate = self
    }
    
    
    /*
     @IBAction func RotateButton(_ sender: UIButton) {
         self.TheImage.image = self.TheImage.image?.rotate(radians: .pi)
         rotated = !rotated
     }
     */
}

