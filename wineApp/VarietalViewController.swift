//
//  VarietalViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class VarietalViewController:UITableViewController {
    
    let cellId = "cellId123123"
    
    var inventory = [
        InventoryByVarietal(isExpanded : false,
                            varietal : "Barbera",
                            producers : ["Zerba"],
                            vintages : ["2017"],
                            avas : ["Walla Walla"],
                            designations : ["The Rocks"],
                            bottleCount : ["3"]),
        InventoryByVarietal(isExpanded : false,
                            varietal : "Chardonnay",
                            producers : ["Stoller"],
                            vintages : ["2015"],
                            avas : ["Dundee Hills"],
                            designations : ["Family Estate"],
                            bottleCount : ["3"]),
        InventoryByVarietal(isExpanded : false,
                            varietal : "Dolcetto",
                            producers : ["Zerba"],
                            vintages : ["2016"],
                            avas : ["Walla Walla"],
                            designations : ["The Rocks"],
                            bottleCount : ["3"]),
        InventoryByVarietal(isExpanded : false,
                            varietal : "Grenache",
                            producers : ["Abacela"],
                            vintages : ["2017"],
                            avas : ["Umpqua Valley"],
                            designations : ["Estate"],
                            bottleCount: ["3","2"]),
        InventoryByVarietal(isExpanded : false,
                            varietal : "Honor Barn Red",
                            producers : ["Roxy Ann"],
                            vintages : ["2014"],
                            avas : ["Rogue Valley"],
                            designations : ["Estate"],
                            bottleCount: ["3"]),
        InventoryByVarietal(isExpanded : false,
                            varietal : "Malbec",
                            producers : ["Del Rio"],
                            vintages : ["2014"],
                            avas : ["Rogue Valley"],
                            designations : [""],
                            bottleCount: ["2"]),
        InventoryByVarietal(isExpanded : false,
                            varietal : "Pinot Noir",
                            producers : ["Hawk's View", "Adelshiem" , "Beckham Estates"],
                            vintages : ["2016","2015","2015"],
                            avas : ["Wilamette Valley", "Dundee Hills" , "Wilamette Valley"],
                            designations : ["Estate", "Elizabeth's Reserve","Sophia's"],
                            bottleCount: ["3","2","1"])
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Varietal"
        
        let moreMenu =   UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action,
                                         target: self,
                                         action: #selector(handleActionMenu))
        navigationItem.rightBarButtonItem = moreMenu
        
        let addWine = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                      target: self,
                                      action: #selector(handleAddWine))
        navigationItem.leftBarButtonItem = addWine
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = inventory[section].varietal + " (" + String(inventory[section].producers.count) + ")"
        let colorOdd = UIColor(r:184, g:206, b:249)
        let colorEven = UIColor(r:202, g:227, b:255)
        
        let button = UIButton(type: .system)
        button.setTitle(sectionTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = section % 2 == 0 ? colorOdd : colorEven
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0,left: 5,bottom: 0,right: 0)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in inventory[section].producers.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded  = inventory[section].isExpanded
        let setionTitle = inventory[section].varietal + " (" + String(inventory[section].producers.count) + ")"
        inventory[section].isExpanded = !isExpanded
        
        button.setTitle(setionTitle, for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return inventory.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !inventory[section].isExpanded {
            return 0
        }
        
        return inventory[section].producers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var wineSelected = wineDetail()
        var section: NSInteger
        var row: NSInteger

        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        section = indexPath![0]
        row = indexPath![1]
        
        //getting the current cell from the index path
        wineSelected.vintage = inventory[section].vintages[row]
        wineSelected.varietal = inventory[section].varietal
        wineSelected.producer = inventory[section].producers[row]
        wineSelected.ava = inventory[section].avas[row]
        wineSelected.designation = inventory[section].designations[row]
        wineSelected.bottleCount = inventory[section].bottleCount[row]

        
        let wineDetailController = wineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
        present(navController, animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let producer = inventory[indexPath.section].producers[indexPath.row]
        let vintage = inventory[indexPath.section].vintages[indexPath.row]
        let ava = inventory[indexPath.section].avas[indexPath.row]
        let designaion = inventory[indexPath.section].designations[indexPath.row]
        
        cell.textLabel?.text = vintage + " " + producer
        if designaion == "" {
            cell.detailTextLabel?.text = ava
        } else {
            cell.detailTextLabel?.text = ava + " - " + designaion
        }
        
        return cell
    }
    
    @objc func handleActionMenu(){
        Alert.showActionMenuAlert(on: self)
    }
    
    @objc func handleAddWine(){
        Alert.showAddBottleAlert(on: self)
    }
    
}
