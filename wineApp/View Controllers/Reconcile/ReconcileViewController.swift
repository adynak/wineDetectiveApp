//
//  LocationViewController.swift
//  wineApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import UIKit

class LocationViewController :UITableViewController {
    
    let cellID = "cellId"

    var bottles: [DrillLevel0]?
    var locationLocations:Set = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellID)
        bottles = allWine?.location
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)

    }
                    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = NSLocalizedString("locationTitle", comment: "title for location")
        let logOutBtn = NSLocalizedString("logOutBtn", comment: "")
                
        let cancelButton = UIBarButtonItem(title: logOutBtn,
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
        bottles = allWine?.location
        self.tableView.reloadData()
        for row in locationLocations{
            if (row < bottles!.count){
                let button = UIButton(type: .system)
                button.tag = row
                handleExpandClose(button: button)
            }
        }
    }

    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        locationLocations.insert(section)
        
        var indexPaths = [IndexPath]()
        for row in bottles![section].data.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isRowExpanded = bottles?[section].isExpanded
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
        
        wineSelected.bottles = bottles![section].data[row].data
        wineSelected.location = bottles![section].name
        wineSelected.bin = bottles![section].data[row].name
        wineSelected.bottleCount = String(bottles![section].data[row].bottleCount!)
        wineSelected.topLeft = bottles![section].name
        wineSelected.topRight = bottles![section].data[row].name
        
        let locationDetailController = DrillDownDetailViewController()
        locationDetailController.passedValue = wineSelected
        locationDetailController.title = NSLocalizedString("locationTitle", comment: "title for location")
        let navController = UINavigationController(rootViewController: locationDetailController)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let bin = bottles?[indexPath.section].data[indexPath.row].name
        let colorOdd = UIColor(r:255, g:255, b:255) //white
        let colorEven = UIColor(r:240, g:240, b:240)
                
        bottleCount = bottles![indexPath.section].data[indexPath.row].bottleCount!
        
        cell.textLabel?.text = "\(bin!) (\(bottleCount))"
        cell.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        return cell
    }
            
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
        
}
