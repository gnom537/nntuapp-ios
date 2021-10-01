//
//  eventDataCells.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 07.08.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit


//MARK: - eventTitleCell
class eventTitleCell: UITableViewCell {

    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    var color : UIColor?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillIn(_ input: event){
        setTime(input)
        authorLabel.text = input.author.uppercased()
        titleLabel.text = input.title
        
        color = input.color
        setTitleColor(getTitleColor())
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setTitleColor(getTitleColor())
    }
    
    func setTime(_ data: event?){
        if (data?.type != "event" || data == nil) {
            dateTimeLabel.text = "Новость".uppercased()
            return
        }
        if let st = data!.startTime{
            let date = Date(timeIntervalSince1970: Double(st)/1000)
            let df = DateFormatter()
            df.dateFormat = "d MMMM HH:mm"
            df.locale = Locale(identifier: "ru")
            dateTimeLabel.text = df.string(from: date).uppercased()
        } else {
            dateTimeLabel.text = "Новость".uppercased()
        }
    }
    
    func getTitleColor() -> UIColor{
        if color == nil {
            return .label
        }
        let backColor = self.backgroundColor
        let backIsDark = backColor?.isDark()
        let eventIsDark = color?.isDark()
        if (backIsDark != eventIsDark){
            return color!
        }
        return .label
    }
    
    func setTitleColor(_ input: UIColor){
        dateTimeLabel.textColor = input
        authorLabel.textColor = input
        titleLabel.textColor = input
    }
}

//MARK: - eventImageCell
class eventImageCell: UITableViewCell {

    @IBOutlet var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImage.layer.cornerRadius = 10
    }
    
    func fillIn(data: event, image: UIImage){
        if image == UIImage(named: "logoPlaceholder"){
            let url = URL(string: data.imageLink!)!
            getImageData(from: url, completion: { result in
                DispatchQueue.main.async {
                    self.eventImage.image = result
                }
            })
        } else {
            eventImage.image = image
        }
    }
}


//MARK: - eventDescriptionCell
class eventDescriptionCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillIn(_ evt: event){
        descriptionLabel.text = evt.description
    }
}

//MARK: - addToCalendarCell
class addToCalendarCell: UITableViewCell {
    
    @IBOutlet var view: UIView!
    @IBOutlet var calendarIcon: UIImageView!
    @IBOutlet var addToCalendarLabel: UILabel!
    
    var data: event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
    }
    
    func fillIn(_ input: event){
        data = input
        
        view.backgroundColor = input.color
        let textColor = getColorForText(backgroundColor: input.color)
        
        calendarIcon.tintColor = textColor
        addToCalendarLabel.textColor = textColor
    }
    
    @IBAction func addToCalendar(_ sender: UIButton) {
        
    }
}

//MARK: - eventPlaceCell
class eventPlaceCell: UITableViewCell {
    
    @IBOutlet var view: UIView!
    @IBOutlet var mapIcon: UIImageView!
    
    
    @IBOutlet var placeDescriprionLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
    }
    
    func fillIn(_ input: event){
        if (UIImage(named: input.place!) != nil){
            placeDescriprionLabel.text = "Аудитория"
            placeLabel.text = input.place
        } else {
            placeDescriprionLabel.text = "Место"
            placeLabel.text = input.place
        }
        
        view.backgroundColor = UIImage(named: input.place!) != nil ? input.color : .secondarySystemBackground
        let textColor = getColorForText(backgroundColor: view.backgroundColor!)
        
        mapIcon.tintColor = textColor
        placeDescriprionLabel.textColor = textColor
        placeLabel.textColor = textColor
    }
    
    
    @IBAction func openPlace(_ sender: Any) {
        
    }
}

//MARK: - eventLinkCell
class eventLinkCell: UITableViewCell{
    
    @IBOutlet var view: UIView!
    @IBOutlet var globe: UIImageView!
    
    
    @IBOutlet var linkDescriptionLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
    }
    
    func fillIn(link: (String, String), color: UIColor){
        linkDescriptionLabel.text = link.0
        linkLabel.text = link.1
        
        view.backgroundColor = color
        let textColor = getColorForText(backgroundColor: color)
        
        linkDescriptionLabel.textColor = textColor
        linkLabel.textColor = textColor
        globe.tintColor = textColor
    }
    
    @IBAction func openLink(_ sender: Any) {
        if let url = URL(string: linkLabel.text!) {
            UIApplication.shared.open(url)
        }
    }
    
}

func getColorForText(backgroundColor: UIColor) -> UIColor{
    if (backgroundColor == .secondarySystemBackground){
        return .label
    }
    if (backgroundColor.isDark()){
        return .white
    } else {
        return .black
    }
}


