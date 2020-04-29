//
//  ViewController.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 9/25/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

protocol BottleCountDelegate {
    func passBackBinsAndBottlesInThem(newBinData:[StorageBins])
}

class wineDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var myUpdater: BottleCountDelegate!
    
    let tableContainerTopAnchor:CGFloat = 200.0
    let tableContainerHeightAnchor:CGFloat = 280.0
    let tableRowHeight:CGFloat = 50
    let sortBins:Bool = true
    
    var cellID = "cellID123"
    var wineBins = [StorageBins]()
    
    var cells = [BinTableViewCell]() //initialize array at class level

    var passedValue = wineDetail()
    
    let wineLabel: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 18)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        return tv
    }()

    let storageLabel: UITextView = {
        let tv = UITextView()
        tv.text = "Location and Bin:\n"
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(r:202, g:227, b:255)
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = true
        return tv
    }()

    let inventoryFooter: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 18)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.text = "total Bottles"
        tv.contentInset=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        return tv
    }()
    
    
    let tableContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        return v
    }()
    
    let wineBinsTableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 5
        return tv
    }()
    
//    private var wineBins = InventoryAPI.getInventory() // model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r:202, g:227, b:255)
        
        setupNavigationBar()
        
        view.addSubview(wineLabel)
        view.addSubview(storageLabel)
        view.addSubview(tableContainer)
        tableContainer.addSubview(wineBinsTableView)
        view.addSubview(inventoryFooter)
        
        wineBins = passedValue.storageBins!

        assignPassedValuesToTextarea()
        setupWineLabelLayout()
        setupInventoryFooterLayout()
        setupWineBinsTableViewLayout()
        
        if sortBins {
            wineBins =  wineBins.sorted(by: {
                ($0.binName?.lowercased())! < ($1.binName?.lowercased())!
            })
        }

    }
    
    func setupInventoryFooterLayout(){
        inventoryFooter.text = getTotalBottles()
        NSLayoutConstraint.activate([
            inventoryFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inventoryFooter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -52),
            inventoryFooter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            inventoryFooter.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant : 6),
            inventoryFooter.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant : -6)
        ])
    }
    
    func setupWineLabelLayout(){
        NSLayoutConstraint.activate([
            wineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant : 22.0),
            wineLabel.heightAnchor.constraint(equalToConstant: 95),
            wineLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant : 6),
            wineLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant : -6)
        ])
        
        NSLayoutConstraint.activate([
            storageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            storageLabel.topAnchor.constraint(equalTo: wineLabel.bottomAnchor, constant : 11.0),
            storageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            storageLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func setupWineBinsTableViewLayout(){
        tableContainer.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableContainer.topAnchor.constraint(equalTo:storageLabel.bottomAnchor, constant:10),
            tableContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant : 6),
            tableContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant : -6),
            tableContainer.heightAnchor.constraint(equalToConstant: tableContainerHeightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            wineBinsTableView.topAnchor.constraint(equalTo:tableContainer.topAnchor, constant: 5),
            wineBinsTableView.leadingAnchor.constraint(equalTo:tableContainer.leadingAnchor, constant: 5),
            wineBinsTableView.trailingAnchor.constraint(equalTo:tableContainer.trailingAnchor, constant: -5),
            wineBinsTableView.bottomAnchor.constraint(equalTo:tableContainer.bottomAnchor, constant: -5)
        ])
        
        wineBinsTableView.dataSource = self
        wineBinsTableView.register(BinTableViewCell.self, forCellReuseIdentifier: cellID)
        wineBinsTableView.rowHeight = tableRowHeight
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineBins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // want to stripe the table's rows?
        let colorOdd = UIColor(r:255, g:255, b:255) //white
        let colorEven = UIColor(r:255, g:255, b:255)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BinTableViewCell
        cell.bin = wineBins[indexPath.row]
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        cell.delegate = self
        
        if(!cells.contains(cell)){
            self.cells.append(cell)
        }
        
        return cell
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Inventory"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addTapped))
    }
    
    
    @objc func addTapped(sender: UIBarButtonItem){
        var newBinData = [StorageBins]()

        if (sender.title == "Save"){
            for cell in cells {
                if let bottles = Int.parse(from: cell.bottleCountLabel.text!) {
                    newBinData.append(StorageBins(binName: cell.binNameLabel.text!, bottleCount:bottles))
                }
                
            }
            myUpdater.passBackBinsAndBottlesInThem(newBinData: newBinData)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func assignPassedValuesToTextarea(){
        
        navigationItem.title = passedValue.producer
        var designation = "";
        var vineyard = ""
        
        if (passedValue.designation != ""){
            designation = " - " + passedValue.designation
        }
        
        if (passedValue.vineyard != ""){
            vineyard = " - " + passedValue.vineyard
        }
        
        if (passedValue.varietal == passedValue.designation){
            designation = ""
        }
        
        let attributedText = NSMutableAttributedString(
            string: passedValue.vintage + " " + passedValue.varietal + designation + "\n",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        attributedText.append(NSAttributedString(
            string: passedValue.ava + vineyard + "\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.gray])
        )
        
        attributedText.append(NSAttributedString(
            string: passedValue.locale + "\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.gray])
        )
        
        attributedText.append(NSAttributedString(
            string: "Drinking Window: " + passedValue.drinkBy + "\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.gray])
        )
                
        wineLabel.attributedText = attributedText
    }
    
    private func getTotalBottles()  -> String {
        var totalBottles = 0
        var bottleString = " bottle"
        for bin in wineBins
        {
            totalBottles += bin.bottleCount!
        }
        if (totalBottles > 1){
          bottleString = " bottles"
        }
        return String(totalBottles) + bottleString
    }

}

extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension wineDetailViewController : BinCellDelegate {
    func didTapStepper(direction: String){
        let minus = "minus" as String
        let plus = "plus" as String
        
        var count = 0
        
        let number = Int.parse(from: inventoryFooter.text!)
        if (direction == minus){
            count = number! - 1
        }
        if (direction == plus){
            count = number!
            let addWineController = AddWineController()
            addWineController.passedValue = passedValue
            let navController = UINavigationController(rootViewController: addWineController)
            present(navController, animated: true, completion: nil)
        }
        
        inventoryFooter.text = String(count) + " bottles"
    }
}
