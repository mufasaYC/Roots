//
//  ButtonCollectionViewCell.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func cellConfigure(item: Item) {
        selectView.isHidden = !item.isSelected
        titleLabel.text = item.title
    }
}
