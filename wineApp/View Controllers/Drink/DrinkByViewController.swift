//
//  FavoriteViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class DrinkByViewController :UITableViewController {
    
    let cellID = "drinkByCellId123123"
    
    var allWines: WineInventory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellID)
        allWines = allWine        
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Drink By"
                
        let moreMenu = UIBarButtonItem(image: UIImage(named: "moreMenu"),
                                       style: .plain,
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
        
        
        let bottleCount = (allWines!.drinkBy?[section].bottleCount)!

        let sectionName = (allWines!.drinkBy?[section].name! == "") ? "Missing" : allWines!.drinkBy![section].name!
        let sectionCount = " (\(bottleCount))"
        
        let sectionTitle = sectionName + sectionCount
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
        for row in allWines!.drinkBy![section].wines!.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isRowExpanded = allWines?.drinkBy?[section].isExpanded
        // set this for call to numberOfRowsInSection to toggle display of these rows
        allWines?.drinkBy?[section].isExpanded = !isRowExpanded!
        
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
            return (allWines?.drinkBy?.count)!
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(allWines?.drinkBy?[section].isExpanded)! {
            return 0
        }
        return (allWines?.drinkBy![section].wines!.count)!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var wineSelected = wineDetail()
        
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        
        //getting the current cell from the index path
        wineSelected.vintage = allWines!.drinkBy![section].wines![row].vintage!
        wineSelected.varietal = allWines!.drinkBy![section].wines![row].producer!
        wineSelected.drinkBy = allWines!.drinkBy![section].wines![row].drinkBy!
        wineSelected.locale = allWines!.drinkBy![section].wines![row].locale!
        wineSelected.producer = allWines!.drinkBy![section].wines![row].varietal!
        wineSelected.ava = allWines!.drinkBy![section].wines![row].ava!
        wineSelected.designation = allWines!.drinkBy![section].wines![row].designation!
        wineSelected.region = allWines!.drinkBy![section].wines![row].region!
        wineSelected.country = allWines!.drinkBy![section].wines![row].country!
        wineSelected.type = allWines!.drinkBy![section].wines![row].type!
        wineSelected.vineyard = allWines!.drinkBy![section].wines![row].vineyard!
        wineSelected.storageBins = allWines!.drinkBy![section].wines![row].storageBins
        
        let wineDetailController = wineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
        wineDetailController.myUpdater = (self as BottleCountDelegate)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let varietal = allWines?.drinkBy?[indexPath.section].wines?[indexPath.row].varietal
        let vintage = allWines?.drinkBy?[indexPath.section].wines?[indexPath.row].vintage
//        var designation = allWines?.producers?[indexPath.section].wines?[indexPath.row].designation
//        let ava = allWines?.drinkBy?[indexPath.section].wines?[indexPath.row].ava
//        let type = allWines?.producers?[indexPath.section].wines?[indexPath.row].type
//        let vineyard = allWines?.drinkBy?[indexPath.section].wines?[indexPath.row].vineyard

        let producer = allWines?.drinkBy?[indexPath.section].wines?[indexPath.row].producer

        
        let bottleLocations = allWines?.drinkBy?[indexPath.section].wines?[indexPath.row].storageBins
        for bin in bottleLocations! {
            bottleCount += bin.bottleCount!
        }
        
        var collective = " bottle)"
        if (bottleCount > 1){
            collective = " bottles)"
        }
        
        cell.textLabel?.text = vintage! + " " + varietal! + " (" + String(bottleCount) + collective
//        if vineyard == "" {
//            cell.detailTextLabel?.text = ava
//        } else {
//            cell.detailTextLabel?.text = ava! + " - " + vineyard!
//        }
        cell.detailTextLabel?.text = producer
        return cell
    }
    
    let settingsLauncher = SettingsLauncher()
    
    @objc func handleActionMenu(){
        settingsLauncher.showSettings()
        
//        Alert.showActionMenuAlert(on: self)
        
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

extension DrinkByViewController: BottleCountDelegate{
    
    func passBackBinsAndBottlesInThem(newBinData:[StorageBins]){
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        allWines!.drinkBy![section].wines![row].storageBins = newBinData
        tableView.reloadData()
    }
    
}
