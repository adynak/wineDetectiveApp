//
//  VideoViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class VintageViewController:UITableViewController {
    
    let cellId = "cellId123123"
    
    var inventory = [
        InventoryByVintage(isExpanded : false,
                  vintage : "2017",
                  producers : ["Abacela","Zerba"],
                  varietals : ["Grenache","Barbera"],
                  avas : ["Umpqua Valley","Walla Walla"],
                  designations : ["Estate","The Rocks"],
                  bottleCount: ["3","2"]),
        InventoryByVintage(isExpanded : false,
                  vintage : "2016",
                  producers : ["Hawk's View","Zerba"],
                  varietals : ["Pinot Noir","Dolcetto"],
                  avas : ["Willamette Valley","Walla Walla"],
                  designations : ["Estate","The Rocks"],
                  bottleCount : ["3","1"]),
        InventoryByVintage(isExpanded : false,
                  vintage : "2015",
                  producers : ["Beckham Estates","Stoller","Adelshiem"],
                  varietals : ["Pinot Noir","Chardonnay","Pinot Noir"],
                  avas : ["Willamette Valley","Dundee Hills","Dundee Hills"],
                  designations : ["Sophia's","Family Estate","Elizabeth's Reserve"],
                  bottleCount : ["3","1"]),
        InventoryByVintage(isExpanded : false,
                  vintage : "2014",
                  producers : ["Roxy Ann","Del Rio"],
                  varietals : ["Honor Barn Red","Malbec"],
                  avas : ["Rogue Valley","Rogue Valley"],
                  designations : ["Estate",""],
                  bottleCount : ["3","1"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Vintage"
        
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
        
        let sectionTitle = inventory[section].vintage + " (" + String(inventory[section].producers.count) + ")"
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
        let setionTitle = inventory[section].vintage + " (" + String(inventory[section].producers.count) + ")"
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
        wineSelected.vintage = inventory[section].vintage
        wineSelected.varietal = inventory[section].varietals[row]
        wineSelected.producer = inventory[section].producers[row]
        wineSelected.ava = inventory[section].avas[row]
        wineSelected.designation = inventory[section].designations[row]
        wineSelected.bottleCount = inventory[section].bottleCount[row]
        
//        Alert.showWineDetailAlert(on: self, with: currentItem!)
        let wineDetailController = wineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
        present(navController, animated: true, completion: nil)
                
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let producer = inventory[indexPath.section].producers[indexPath.row]
        let varietal = inventory[indexPath.section].varietals[indexPath.row]
        let ava = inventory[indexPath.section].avas[indexPath.row]
        let designaion = inventory[indexPath.section].designations[indexPath.row]
        
        cell.textLabel?.text = producer + " " + varietal
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

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
