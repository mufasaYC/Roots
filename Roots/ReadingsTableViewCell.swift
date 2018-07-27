//
//  ReadingsTableViewCell.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

var optimumTemp = 28.0
var optimumLight = 3800.0
var optimumHumidity = 50.0

class ReadingsTableViewCell: UITableViewCell {

    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(data: PlantData) {
        
        switch data.type {
        case .temp:
            readingLabel.text = tempText(temp: data.value)
        case .humidity:
            readingLabel.text = humText(hum: data.value)
        case .light:
            readingLabel.text = lightText(light: data.value)
        case .moisture:
            readingLabel.text = ""
        }
        
        valueLabel.text = String(describing: floor(data.value*100)/100)
        let x = data.time
        timeLabel.text = x < 1 ? "Just\nUpdated" : (x == 1 ? "Before\n\(x) hour" : "Before\n\(x) hours")
    }
    
    func tempText(temp: Double) -> String {
        if temp > (optimumTemp + 3.0) {
            return "High"
        } else if temp < optimumTemp - 3.0 {
            return "Cool"
        }
        return "Optimum"
    }
    
    func humText(hum: Double) -> String {
        if hum > (optimumHumidity + 10.0) {
            return "High humidity"
        } else if hum < optimumTemp - 10.0 {
            return "Low humidity"
        }
        return "Perfect"
    }

    func lightText(light: Double) -> String {
        if light > optimumLight {
            return "Sunny"
        } else if light < 1000.0 {
            return "Poor light reach"
        }
        return "Medium light"
    }

    
}
