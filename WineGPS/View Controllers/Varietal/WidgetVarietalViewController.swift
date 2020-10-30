//
//  VarietalViewController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class WidgetVarietalViewController : UITableViewController {
    
    var widgetVarietal : String = ""

    let cellID = "cellId"

    var bottles: [DrillLevel0]?
    var locationLocations:Set = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(widgetVarietal)

        
        setupNavBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellID)
        bottles = allWine?.varietals
        
        if let varietalIndex = bottles!.firstIndex(where: { $0.name == widgetVarietal }) {
            print(varietalIndex)
            bottles?[varietalIndex].isExpanded = true
//            scrollToSelectedRow(selectedRow:varietalIndex)
            let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
            self.tableView.setContentOffset(scrollPoint, animated: true)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name(rawValue: "removeBottles"), object: nil)

    }
                    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = NSLocalizedString("titleVarietal", comment: "navagation title: varietal")
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
        bottles = allWine?.varietals
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
        var wineSelected = WineDetail()
        
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        let section = indexPath![0]
        let row = indexPath![1]
        
        wineSelected.bottles = bottles![section].data[row].data
        wineSelected.location = bottles![section].name
        wineSelected.bin = bottles![section].data[row].name
        wineSelected.bottleCount = String(bottles![section].data[row].bottleCount!)
        wineSelected.topLeft = bottles![section].data[row].data[0].producer
        wineSelected.topRight = bottles![section].data[row].data[0].varietal
        wineSelected.viewName = "varietal"
        
        let detailController = DrillDownDetailViewController()
        detailController.passedValue = wineSelected
        detailController.title = NSLocalizedString("titleVarietal", comment: "navagation title: varietal")
        let navController = UINavigationController(rootViewController: detailController)
        present(navController, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bottleCount: Int
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let bin = bottles?[indexPath.section].data[indexPath.row].name
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
        
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
        
    }
    
    func scrollToSelectedRow(selectedRow:Int) {
        let indexPath : IndexPath = [selectedRow,0]
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .middle, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                // do here...
                tableView.tableViewScrollToBottom(animated: true)
            }
        }
    }
            
}

extension UITableView {

    func tableViewScrollToBottom(animated: Bool) {

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {

            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 20-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    }
}
