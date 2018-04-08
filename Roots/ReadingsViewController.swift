//
//  ReadingsViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ReadingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var item = [Item(title: "Temperature", isSelected: true), Item(title: "Humidity", isSelected: false), Item(title: "Luminance", isSelected: false)]
    
    var plantData = [[PlantData](), [PlantData](), [PlantData]()]
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ReadingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantData[selectedIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReadingsTableViewCell
        let data = plantData[selectedIndex][indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension ReadingsViewController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ButtonCollectionViewCell
        cell.cellConfigure(item: item[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(item: selectedIndex, section: 0)
        item[indexPath.item].isSelected = !item[indexPath.item].isSelected
        item[index.item].isSelected = !item[index.item].isSelected
        collectionView.reloadItems(at: [index, indexPath])
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3, height: collectionView.bounds.height)
    }
    
}
