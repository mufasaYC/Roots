//
//  StatViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StatViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet var width: [NSLayoutConstraint]!
    @IBOutlet var percentageLabels: [UILabel]!
    @IBOutlet var progressView: [UIView]!
    
    var plantsData: [[PlantData]]? {
        didSet {
            guard let p = plantsData else { return }
            let temp = p[0]
            var sumTemp = 0.0
            for i in temp.enumerated() {
                if i.offset == 24 { break }
                sumTemp += i.element.value
            }
            let hum = p[1]
            var sumHum = 0.0
            for i in hum.enumerated() {
                if i.offset == 24 { break }
                sumHum += i.element.value
            }
            let light = p[2]
            var sumLight = 0.0
            for i in light.enumerated() {
                if i.offset == 24 { break }
                sumLight += i.element.value
            }
            let moist = p[3]
            var sumMoist = 0.0
            for i in moist.enumerated() {
                if i.offset == 24 { break }
                sumMoist += i.element.value
            }
            setupViews(array: [sumTemp/24.0, sumHum/24.0, sumLight/24.0, sumMoist/24.0])
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setupViews(array: [0,0,0, 0])
    }

    func setupViews(array: [Double]) {
        
        let t = (array[0] / 28.0) > 1.0 ? 1.0 : (array[0] / 28.0)
        let h = (array[1] / 52.0) > 1.0 ? 1.0 : (array[1] / 52.0)
        let l = (array[2] / 3800) > 1.0 ? 1.0 : (array[2] / 3800)
        let w = array[3]
        let x = [w, l, (h+w+l+t)/4]
        
        for i in 0 ... 2 {
            percentageLabels[i].text = String(describing: Int(floor(x[i]*100))) + "%"
            self.width[i].constant = (240.0*(CGFloat(x[i])))
        }
        
        UIView.animate(withDuration: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        
        let m = min(w, l, t)
        if x[2] > 0.9 {
            descLabel.text = "Thank you for taking good care of me"
            return
        }
        if m == w {
            descLabel.text = "I am feeling parched!"
            if h < optimumHumidity {
                descLabel.text = "I am feeling parched and it's humid!"
            }
        } else if m == l {
             descLabel.text = "I need more sunlight!"
        } else if m == t {
            descLabel.text = "I am feeling very cold!"
        }
        
        
        
    }
    
}
