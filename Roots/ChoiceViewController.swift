
//
//  ChoiceViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 12/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit
import Firebase

class ChoiceViewController: UICollectionViewController {

    var plants = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "plant") as? String {
            performSegue(withIdentifier: "x", sender: self)
        }
    }
    
    func setup() {
        Database.database().reference().child("plants").observe(.value) { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                self.plants.removeAll()
                for i in data.enumerated() {
                    self.plants.append(i.element.key)
                }
                self.collectionView?.reloadData()
            }
        }

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChoiceCollectionViewCell
        cell.titleLabel.text = String(describing: plants[indexPath.item].first!)
        cell.descLabel.text = plants[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(plants[indexPath.item], forKey: "plant")
        plant = plants[indexPath.row]
    }
    
}
