//
//  FavoriteViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class VarietalViewController :UITableViewController {
    
    let cellID = "varietalCellId123123"
    
    var varietals: [Producers]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellID)
        varietals = allWine?.varietals
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Varietal"
        
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
        
        let sectionName = (varietals?[section].name)!
        let bottleCount = (varietals?[section].bottleCount)!

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
        for row in varietals![section].wines!.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isRowExpanded = varietals?[section].isExpanded
        // set this for call to numberOfRowsInSection to toggle display of these rows
        varietals?[section].isExpanded = !isRowExpanded!
        
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
        if varietals == nil {
            return 0
        } else {
            return (varietals?.count)!
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(varietals?[section].isExpanded)! {
            return 0
        }
        return (varietals![section].wines!.count)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var wineSelected = wineDetail()
        
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        
        //getting the current cell from the index path
        wineSelected.vintage = varietals![section].wines![row].vintage!
        wineSelected.varietal = varietals![section].wines![row].producer!
        wineSelected.drinkBy = varietals![section].wines![row].drinkBy!
        wineSelected.locale = varietals![section].wines![row].locale!
        wineSelected.producer = varietals![section].name!
        wineSelected.ava = varietals![section].wines![row].ava!
        wineSelected.designation = varietals![section].wines![row].designation!
        wineSelected.region = varietals![section].wines![row].region!
        wineSelected.country = varietals![section].wines![row].country!
        wineSelected.type = varietals![section].wines![row].type!
        wineSelected.vineyard = varietals![section].wines![row].vineyard!
        wineSelected.storageBins = varietals![section].wines![row].storageBins
        
        let wineDetailController = wineDetailViewController()
        wineDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: wineDetailController)
        wineDetailController.myUpdater = (self as BottleCountDelegate)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let varietal = varietals?[indexPath.section].wines?[indexPath.row].producer
        let vintage = varietals?[indexPath.section].wines?[indexPath.row].vintage
//        var designation = producers?[indexPath.section].wines?[indexPath.row].designation
        let ava = varietals?[indexPath.section].wines?[indexPath.row].ava
//        let type = producers?[indexPath.section].wines?[indexPath.row].type
        let vineyard = varietals?[indexPath.section].wines?[indexPath.row].vineyard

        
        let bottleLocations = varietals?[indexPath.section].wines?[indexPath.row].storageBins
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

extension VarietalViewController: BottleCountDelegate{
    
    func passBackBinsAndBottlesInThem(newBinData:[StorageBins]){
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        varietals![section].wines![row].storageBins = newBinData
        tableView.reloadData()
    }
    
}
