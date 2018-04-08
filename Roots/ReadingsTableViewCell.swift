//
//  ReadingsTableViewCell.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ReadingsTableViewCell: UITableViewCell {

    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(data: PlantData) {
        readingLabel.text = String(describing: floor(data.value*100)/100)
        let x = Int(floor(Double(Date().timeIntervalSince1970 - data.time)/60))
        timeLabel.text = x < 1 ? "Just Updated" : (x == 1 ? "Before\n\(x) minute" : "Before\n\(x) minutes")
    }
}
