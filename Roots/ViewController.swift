//
//  ViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Item {
    var title: String
    var isSelected: Bool
}

struct PlantData {
    var time: Int
    var value: Double
    var type: Type
}

enum Type {
    case light, humidity, moisture, temp
}

var plant = "Corn"

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var item = [Item(title: "Status", isSelected: true), Item(title: "Profile", isSelected: false)]
    
    var plantData = [[PlantData](), [PlantData](), [PlantData](), [PlantData]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        getData()
    }

    func getData() {
        Database.database().reference().child("sensor").child("dht").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var x = [PlantData]()
                var x1 = [PlantData]()
                for i in data.enumerated() {
                    if let v = i.element.value as? NSDictionary {
                        let t = TimeInterval(i.element.key) ?? TimeInterval(0)/1000.0
                        let y = Int(floor(Double(Date().timeIntervalSince1970 - t/1000.0)/6000))
                        x.append(PlantData(time: y, value: v["temp"] as? Double ?? 31.3, type: .temp))
                        x1.append(PlantData(time: y, value: v["humidity"] as? Double ?? 31.3, type: .humidity))
                    }
                }
//                self.plantData[0] = x
//                self.plantData[1] = x1
                print(x1, "\n\n\n")
                self.averageHum(data: x1)
                self.averageTemp(data: x)
                print("Temp: ", x.count)
                print("Hum: ", x1.count)
//                self.steupChild()
            }
        }
        
        Database.database().reference().child("sensor").child("light").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var x = [PlantData]()
                for i in data.enumerated() {
                    if let v = i.element.value as? Double {
                        let t = TimeInterval(i.element.key) ?? TimeInterval(0)/1000.0
                        let y = Int(floor(Double(Date().timeIntervalSince1970 - t/1000.0)/6000))
                        x.append(PlantData(time: y, value: v, type: .light))
                    }
                }
                print("Light: ", x.count)
                self.averageLight(data: x)
//                self.plantData[2] = x
//                self.steupChild()
            }
        }
        
        Database.database().reference().child("sensor").child("soil").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var x = [PlantData]()
                for i in data.enumerated() {
                    if let v = i.element.value as? Double {
                        let t = TimeInterval(i.element.key) ?? TimeInterval(0)/1000.0
                        let y = Int(floor(Double(Date().timeIntervalSince1970 - t/1000.0)/6000))
                        x.append(PlantData(time: y, value: v, type: .moisture))
                    }
                }
                print("Soil: ", x.count)
                self.plantData[3] = x
                self.steupChild()
            }
        }
        
        if let x = UserDefaults.standard.string(forKey: "plant") {
            plant = x
        }
        
        Database.database().reference().child("plants").child(plant).observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                for i in data.enumerated() {
                    if let v = i.element.value as? Double {
                        if i.element.key == "humidity" {
                            optimumHumidity = v
                        } else if i.element.key == "light" {
                            optimumLight = v
                        } else if i.element.key == "temp" {
                            optimumTemp = v
                        }
                    }
                }
                self.steupChild()
            }
        }
    }
    @IBAction func barButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "plant")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "c", sender: self)
    }
    
    func averageHum(data: [PlantData]) {
        
        var x = 0
        let d = data.sorted { (x, y) -> Bool in
            return x.time < y.time
        }
        x = d.first?.time ?? 0
        var new = [PlantData]()
        var sum = 0.0
        var count = 0
        for i in d.enumerated() {
            if i.element.time == x {
                sum = sum + i.element.value
                count += 1
                if i.offset == d.count - 1 {
                    new.append(PlantData(time: x, value: sum/Double(count == 0 ? 1 : count), type: i.element.type))
                }
            } else {
                new.append(PlantData(time: x, value: sum/Double(count == 0 ? 1 : count), type: i.element.type))
                x = i.element.time
                sum = 0.0
                count = 0
            }
        }
        
        self.plantData[1] = new
        steupChild()

    }

    func averageTemp(data: [PlantData]) {
        
        var x = 0
        let d = data.sorted { (x, y) -> Bool in
            return x.time < y.time
        }
        x = d.first?.time ?? 0
        var new = [PlantData]()
        var sum = 0.0
        var count = 0
        for i in d.enumerated() {
            if i.element.time == x {
                sum = sum + i.element.value
                count += 1
                if i.offset == d.count - 1 {
                    new.append(PlantData(time: x, value: sum/Double(count == 0 ? 1 : count), type: i.element.type))
                }
            } else {
                new.append(PlantData(time: x, value: sum/Double(count == 0 ? 1 : count), type: i.element.type))
                x = i.element.time
                sum = 0.0
                count = 0
            }
        }
        
        self.plantData[0] = new
        steupChild()
        
    }

    func averageLight(data: [PlantData]) {
        
        var x = 0
        let d = data.sorted { (x, y) -> Bool in
            return x.time < y.time
        }
        x = d.first?.time ?? 0
        var new = [PlantData]()
        var sum = 0.0
        var count = 0
        for i in d.enumerated() {
            if i.element.time == x {
                sum = sum + i.element.value
                count += 1
                if i.offset == d.count - 1 {
                    new.append(PlantData(time: x, value: sum/Double(count == 0 ? 1 : count), type: i.element.type))
                }
            } else {
                new.append(PlantData(time: x, value: sum/Double(count == 0 ? 1 : count), type: i.element.type))
                x = i.element.time
                sum = 0.0
                count = 0
            }
        }
        
        self.plantData[2] = new
        steupChild()
        
    }

    
    func steupChild() {
        if let p = childViewControllers.first as? PageViewController {
            for i in p.childViewControllers {
                if let vc = i as? ReadingsViewController {
                    vc.plantData = plantData
                    vc.tableView.reloadData()
                }
                if let vc = i as? StatViewController {
                    vc.plantsData = plantData
                }

            }
        }
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ButtonCollectionViewCell
        cell.cellConfigure(item: item[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(item: (indexPath.item == 0 ? 1 : 0), section: 0)
        item[indexPath.item].isSelected = !item[indexPath.item].isSelected
        item[index.item].isSelected = !item[index.item].isSelected
        collectionView.reloadItems(at: [index, indexPath])
        if let p = childViewControllers.first as? PageViewController {
            p.goToPage(id: item[indexPath.item].title, direction: indexPath.item == 0 ? .reverse : .forward)
            steupChild()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: collectionView.bounds.height)
    }
    
}
