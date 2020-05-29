//
//  FavoriteViewController.swift
//  TabbarApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class ReconcileViewController :UITableViewController {
    
    let cellID = "varietalCellId123123"

    var varietals: [Producers]?
    var bottles: [Level0]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        varietals = allWine?.reconcile1
        bottles = allWine?.reconcile
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "UserlistUpdate"), object: nil)

    }
                    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Reconcile"
        
        let moreMenu =   UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action,
                                         target: self,
                                         action: #selector(handleActionMenu))
//        navigationItem.rightBarButtonItem = moreMenu
        
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
        
        let sectionName = (bottles?[section].name)!
        let bottleCount = (bottles?[section].bottleCount)!

        let sectionTitle = "\(sectionName) (\(bottleCount))"
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
    
    @objc func handleReload() {
        bottles = allWine?.reconcile

        self.tableView.reloadData()
    }

    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in bottles![section].data.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isRowExpanded = bottles?[section].isExpanded
        // set this for call to numberOfRowsInSection to toggle display of these rows
        bottles?[section].isExpanded = !isRowExpanded!
        
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
        if bottles == nil {
            return 0
        } else {
            return (bottles?.count)!
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(bottles?[section].isExpanded)! {
            return 0
        }
        return (bottles![section].data.count)
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
       
        wineSelected.bottles = bottles![section].data[row].data
        wineSelected.location = bottles![section].name
        wineSelected.bin = bottles![section].data[row].name
        wineSelected.bottleCount = String(bottles![section].data[row].bottleCount!)
        
        let reconcileDetailController = ReconcileViewDetailController()
        reconcileDetailController.passedValue = wineSelected
        let navController = UINavigationController(rootViewController: reconcileDetailController)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let bin = bottles?[indexPath.section].data[indexPath.row].name
        let colorOdd = UIColor(r:255, g:255, b:255) //white
        let colorEven = UIColor(r:240, g:240, b:240)
                
        bottleCount = bottles![indexPath.section].data[indexPath.row].bottleCount!
//        var collective = " bottle)"
//        if (bottleCount > 1){
//            collective = " bottles)"
//        }
        
        cell.textLabel?.text = "\(bin!) (\(bottleCount))"
//        if vineyard == "" {
//            cell.detailTextLabel?.text = "  \(bottleCount) \(collective)"
//        } else {
//            cell.detailTextLabel?.text = ava! + " - " + vineyard!
//        }
        
        cell.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
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
