//
//  LocationViewController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class LocationViewController :UITableViewController {
    
    let cellID = "cellId"

    var bottles: [DrillLevel0]?
    var locationLocations:Set = Set<Int>()
    
    let refreshControlL: UIRefreshControl = {
        let spinnerText = NSLocalizedString("runAPI", comment: "textfield label: Getting Your Wines, text below animation while waiting for download")
        let rc = UIRefreshControl()
        rc.tintColor = barTintColor
        rc.attributedTitle = NSAttributedString(string: spinnerText, attributes: [
            NSAttributedString.Key.foregroundColor: barTintColor,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ])
        return rc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellID)
        tableView.refreshControl = refreshControlL
        
        bottles = allWine?.location
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)

        refreshControlL.addTarget(self, action: #selector(reloadSourceData(_:)), for: .valueChanged)
    }
                    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = NSLocalizedString("titleLocation", comment: "navagation title: location")
        let logOutBtn = NSLocalizedString("buttonLogOut", comment: "button text: Log Out")
                
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
        let colorOdd = tableStripeOdd
        let colorEven = tableStripeEven
        
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

    @objc private func reloadSourceData(_ sender: Any) {
        let results = API.load()
        bottles = allWine?.location

        switch apiResults(rawValue: results)! {
            case .Failed :
                Alert.showAPIFailedsAlert(on: self)
                DataServices.endRefreshing(tv: tableView, rc: refreshControl!)
            case .NoInternet:
                Alert.noInternetAlert(on: self)
                DataServices.endRefreshing(tv: tableView, rc: refreshControl!)
            case .Success:
                break
        }
        
        DispatchQueue.main.async {
            self.refreshControlL.endRefreshing()
            self.tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
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
        var wineSelected = WineDetail()
        
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
        wineSelected.viewName = "location"
                
        wineSelected.bottles = wineSelected.bottles?.sorted {
            var isSorted = false
            if let first = $0.producer, let second = $1.producer {
                isSorted = first < second
            }
            return isSorted
        }
        
        let locationDetailController = DrillDownDetailViewController()
        locationDetailController.passedValue = wineSelected
        locationDetailController.title = NSLocalizedString("titleLocation", comment: "navagation title: location")
        let navController = UINavigationController(rootViewController: locationDetailController)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var bin = bottles?[indexPath.section].data[indexPath.row].name
        if bin == "" {
            bin = NSLocalizedString("noBin", comment: "textfield label: unassigned (used when the bin is blank")
        }
        let colorOdd = tableStripeWhite
        let colorEven = tableStripeGray
                
        bottleCount = bottles![indexPath.section].data[indexPath.row].bottleCount!
        
        cell.textLabel?.text = "\(bin!) (\(bottleCount))"
        cell.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        return cell
    }
            
    @objc func handleLogOut(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setWidgetVarietal(value: "")

        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
        
    }
        
}
