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
    var time: TimeInterval
    var value: Double
    var type: Type
}

enum Type {
    case light, humidity, moisture, temp
}

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
                for i in data.enumerated() {
                    if let v = i.element.value as? NSDictionary {
                        x.append(PlantData(time: TimeInterval(i.element.key) ?? (Date().timeIntervalSince1970 - TimeInterval(i.offset)*6000), value: v["temp"] as? Double ?? 31.3, type: .temp))
                    }
                }
                self.plantData[0] = x
                print("Temp: ", x.count)
                self.steupChild()
            }
        }
        
        Database.database().reference().child("sensor").child("dht").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var x = [PlantData]()
                for i in data.enumerated() {
                    if let v = i.element.value as? NSDictionary {
                        x.append(PlantData(time: TimeInterval(i.element.key) ?? (Date().timeIntervalSince1970 - TimeInterval(i.offset)*6000), value: v["humidity"] as? Double ?? 31.3, type: .humidity))
                    }
                }
                self.plantData[1] = x
                print("Hum: ", x.count)
                self.steupChild()
            }
        }

        
        Database.database().reference().child("sensor").child("light").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var x = [PlantData]()
                for i in data.enumerated() {
                    if let v = i.element.value as? Double {
                        x.append(PlantData(time: TimeInterval(i.element.key) ?? (Date().timeIntervalSince1970 - TimeInterval(i.offset)*6000), value: v, type: .light))
                    }
                }
                print("Light: ", x.count)
                self.plantData[2] = x
                self.steupChild()
            }
        }
        
        Database.database().reference().child("sensor").child("soil").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                var x = [PlantData]()
                for i in data.enumerated() {
                    if let v = i.element.value as? Double {
                        x.append(PlantData(time: TimeInterval(i.element.key) ?? (Date().timeIntervalSince1970 - TimeInterval(i.offset)*6000), value: v, type: .moisture))
                    }
                }
                print("Soil: ", x.count)
                self.plantData[3] = x
                self.steupChild()
            }
        }
        
        Database.database().reference().child("optimum").observe(.value) { (snapshot) in
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
