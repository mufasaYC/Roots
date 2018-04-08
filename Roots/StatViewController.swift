//
//  StatViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {

    @IBOutlet var width: [NSLayoutConstraint]!
    @IBOutlet var percentageLabels: [UILabel]!
    @IBOutlet var progressView: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }

    func setupViews() {
        for i in 0 ... 2 {
            let x = Int(arc4random()%100)
            percentageLabels[i].text = String(describing: x)
            UIView.animate(withDuration: 0.7, animations: {
                self.width[i].constant = 240.0*(CGFloat(x)/CGFloat(100.0))
            })
        }
    }

}
