//
//  FavoriteViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class ProducerViewController:UITableViewController {
    
    let cellID = "cellId123123"
    
    var allWines: WineInventory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        fetchWineInventory { (wineInventory) -> () in
            self.allWines = wineInventory
            self.tableView.reloadData()
            allWine = wineInventory
        }
                
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = "Producer"
        
        let moreMenu =   UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action,
                                         target: self,
                                         action: #selector(handleActionMenu))
        navigationItem.rightBarButtonItem = moreMenu
        
//        let addWine = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
//                                      target: self,
//                                      action: #selector(handleAddWine))
        
        let cancelButton = UIBarButtonItem(title: "Log Out",
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(handleLogOut))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionName = (allWines!.producers?[section].name)!
        let bottleCount = (allWines!.producers?[section].bottleCount)!

        let sectionTitle = sectionName + " (\(bottleCount))"
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
        for row in allWines!.producers![section].wines!.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isRowExpanded = allWines?.producers?[section].isExpanded
        // set this for call to numberOfRowsInSection to toggle display of these rows
        allWines?.producers?[section].isExpanded = !isRowExpanded!
        
        if isRowExpanded! {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if allWines == nil {
            return 0
        } else {
            return (allWines?.producers?.count)!
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(allWines?.producers?[section].isExpanded)! {
            return 0
        }
        return (allWines?.producers![section].wines!.count)!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var wineSelected = wineDetail()
        
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        
        //getting the current cell from the index path
        wineSelected.vintage = allWines!.producers![section].wines![row].vintage!
        wineSelected.varietal = allWines!.producers![section].wines![row].varietal!
        wineSelected.drinkBy = allWines!.producers![section].wines![row].drinkBy!
        wineSelected.locale = allWines!.producers![section].wines![row].locale!
        wineSelected.producer = allWines!.producers![section].name!
        wineSelected.ava = allWines!.producers![section].wines![row].ava!
        wineSelected.designation = allWines!.producers![section].wines![row].designation!
        wineSelected.region = allWines!.producers![section].wines![row].region!
        wineSelected.country = allWines!.producers![section].wines![row].country!
        wineSelected.type = allWines!.producers![section].wines![row].type!
        wineSelected.vineyard = allWines!.producers![section].wines![row].vineyard!
        wineSelected.storageBins = allWines!.producers![section].wines![row].storageBins
        
        let wineDetailController = wineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
        wineDetailController.myUpdater = (self as BottleCountDelegate)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let varietal = allWines?.producers?[indexPath.section].wines?[indexPath.row].varietal
        let vintage = allWines?.producers?[indexPath.section].wines?[indexPath.row].vintage
//        var designation = allWines?.producers?[indexPath.section].wines?[indexPath.row].designation
        let ava = allWines?.producers?[indexPath.section].wines?[indexPath.row].ava
//        let type = allWines?.producers?[indexPath.section].wines?[indexPath.row].type
        let vineyard = allWines?.producers?[indexPath.section].wines?[indexPath.row].vineyard

        
        let bottleLocations = allWines?.producers?[indexPath.section].wines?[indexPath.row].storageBins
        for bin in bottleLocations! {
            bottleCount += bin.bottleCount!
        }
        
        var collective = " bottle)"
        if (bottleCount > 1){
            collective = " bottles)"
        }
        
        cell.textLabel?.text = vintage! + " " + varietal! + " (" + String(bottleCount) + collective
        if vineyard == "" {
            cell.detailTextLabel?.text = ava
        } else {
            cell.detailTextLabel?.text = ava! + " - " + vineyard!
        }
        
        return cell
    }
    
    @objc func handleActionMenu(){
        Alert.showActionMenuAlert(on: self)
    }
    
    @objc func handleAddWine(){
//        let addWineController = AddWineController()
////        wineDetailController.passedValue = wineSelected
//        let navController = UINavigationController(rootViewController: addWineController)
//        present(navController, animated: true, completion: nil)
        
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
}


extension ProducerViewController: BottleCountDelegate{
    
    func passBackBinsAndBottlesInThem(newBinData:[StorageBins]){
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        allWines!.producers![section].wines![row].storageBins = newBinData
        tableView.reloadData()
    }
    
}
