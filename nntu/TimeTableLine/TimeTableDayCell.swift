//
//  TimeTableDayCell.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 28.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

class TimeTableDayCell: UITableViewCell {
    
    @IBOutlet var AllView: UIView!

    @IBOutlet var ButtonViews: [UIView]!
    @IBOutlet var SeparatorViews: [UIView]!
    @IBOutlet var DayName: UILabel!
    
    @IBOutlet var StartTimes: [UILabel]!
    @IBOutlet var StopTimes: [UILabel]!
    @IBOutlet var Names: [UILabel]!
    @IBOutlet var ButtonLabels: [UILabel]!
    
    
    var TimeTableData = Day()
    var neededColor = NNTUblue
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AllView.layer.cornerRadius = 14
        //AllView.layer.borderColor = neededColor.withAlphaComponent(0.5).cgColor
        //AllView.layer.borderWidth = 3
        updateColor()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateColor (){
        if neededColor == NNTUblue {
            AllView.backgroundColor = UIColor(named: "NNTUblueBackground")
        } else if neededColor == NNTUred {
            AllView.backgroundColor = UIColor(named: "NNTUredBackground")
        }
        
        for i in 0...5 {
            ButtonViews[i].backgroundColor = AllView.backgroundColor
            ButtonViews[i].layer.cornerRadius = 5
            
        }
        for i in 0...4 {
            SeparatorViews[i].backgroundColor = neededColor
            SeparatorViews[i].alpha = 0.3
        }
    }
    
    
    func getButtonIndex (input: UIButton) -> Int{
        for i in 0...5{
            if input.superview == ButtonViews[i]{
                return i
            }
        }
        print ("Индекс кнопки в ячейке не найден")
        return 0
    }
    
    
    
    
    

}
