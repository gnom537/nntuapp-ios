//
//  EventTableViewCell.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 07.08.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var contentCard: UIView!
    @IBOutlet var titleView: UIView!
    

    @IBOutlet var DateTimeLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var previewImage: UIImageView!
    
    var data: event?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentCard.clipsToBounds = true
        contentCard.layer.cornerRadius = 20
        // Initialization code
    }
    
    public func fillIn(_ input: event, image: UIImage?, callback: @escaping (UIImage) -> (Void)){
        data = input
        setColor(data?.color)
        authorLabel.text = input.author.uppercased()
        titleLabel.text = input.title
        setTime(data: input)
        if let image = image {
            self.previewImage.image = image
        } else {
            setImage(input.imageLink, callback: callback)
        }
    }
    
    func setLabelColor(_ color: UIColor){
        DateTimeLabel.textColor = color
        authorLabel.textColor = color
        titleLabel.textColor = color
    }
    
    func setColor(_ color: UIColor?){
        guard let color = color else {return}
        titleView.backgroundColor = color
        if color == .secondarySystemBackground {
            setLabelColor(.label)
            return
        }
        
        if (color.isDark()){
            setLabelColor(.white)
        } else {
            setLabelColor(.black)
        }
    }
    
    func setTime(data: event?){
        if (data?.type != "event" || data == nil) {
            DateTimeLabel.text = "Новость".uppercased()
            return
        }
        if let st = data!.startTime{
            let date = Date(timeIntervalSince1970: Double(st)/1000)
            let df = DateFormatter()
            df.dateFormat = "d MMMM HH:mm"
            df.locale = Locale(identifier: "ru")
            DateTimeLabel.text = df.string(from: date).uppercased()
        } else {
            DateTimeLabel.text = "Новость".uppercased()
        }
    }
    
    func setImage(_ imageLink: String?, callback: @escaping (UIImage) -> (Void)){
        if let link = imageLink {
            if let url = URL(string: link) {
                getImageData(from: url, completion: { result in
                    if let image = result {
                        DispatchQueue.main.async {
                            self.previewImage.image = image
                            callback(image)
                        }
                    }
                })
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class eventsLoadingCell: UITableViewCell {
    
    @IBOutlet var loadingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.layer.cornerRadius = 20
    }
}
