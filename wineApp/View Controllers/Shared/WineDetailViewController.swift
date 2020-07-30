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

class WineDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var myUpdater: BottleCountDelegate!
    
    var tableContainerTopAnchor:CGFloat = 200.0
    var tableContainerHeightAnchor:CGFloat = UIScreen.main.bounds.height - 327
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
        tv.text = NSLocalizedString("locationAndBin", comment: "location and bin")
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = storageLabelBackgroundColor
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
        tv.text = NSLocalizedString("totalBottles", comment: "plural : total bottles")
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = storageLabelBackgroundColor
        
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
            inventoryFooter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            inventoryFooter.heightAnchor.constraint(equalToConstant: 40),
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
        var tableRowHeight: CGFloat
        
        if UserDefaults.standard.getShowBarcode() {
            tableRowHeight = 66
        } else {
            tableRowHeight = 46
        }

        tableContainer.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableContainer.topAnchor.constraint(equalTo:storageLabel.bottomAnchor, constant:10),
            tableContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant : 6),
            tableContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant : -6),
            tableContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110),
//            tableContainer.heightAnchor.constraint(equalToConstant: tableContainerHeightAnchor)
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
        let colorOdd = tableStripeWhite
        let colorEven = tableStripeGray
        
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
        navigationItem.title = NSLocalizedString("titleInventory", comment: "navigation: Inventory")

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("buttonCancel", comment: "cancel button"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("buttonSave", comment: "navigation save button"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addTapped))
    }
    
    
//    @objc func addTapped(sender: UIBarButtonItem){
//        var newBinData = [StorageBins]()
//
//        if (sender.title == "Save"){
//            for cell in cells {
//                if let bottles = Int.parse(from: cell.bottleCountLabel.text!) {
//                    newBinData.append(StorageBins(binName: cell.binNameLabel.text!, bottleCount:bottles))
//                }
//
//            }
////            myUpdater.passBackBinsAndBottlesInThem(newBinData: newBinData)
//        }
//        dismiss(animated: true, completion: nil)
//    }
    
        @objc func addTapped(sender: UIBarButtonItem){
            var markAsDrank = [DrillLevel2]()
            var iwine: String = ""

            if (sender.title == NSLocalizedString("buttonSave", comment: "navigation save button")){
                for cell in cells {
                    if let bottles = Int.parse(from: cell.bottleCountLabel.text!) {
                        if bottles == 0{
                            
                            for bin in passedValue.storageBins!{
                                if bin.barcode == cell.barcodeLabel.text {
                                    iwine = bin.iwine!
                                }
                            }
                            
                            markAsDrank.append(DrillLevel2(
                                producer: passedValue.producer,
                                varietal: passedValue.varietal,
                                vintage: passedValue.vintage,
                                iWine: iwine,
                                barcode: cell.barcodeLabel.text!
                            ))
                        }
                    }
                }
                if markAsDrank.count > 0{
                    let alertTitle = NSLocalizedString("markAsDrankTitle", comment: "alert title mark as drank")
                    let okBtn = NSLocalizedString("okBtn", comment: "OK button")
                    let cancelBtn = NSLocalizedString("buttonCancel", comment: "cancel button")
    //                let message = buildRemoveMessage(bottles: markAsDrank)
                    let message = ""

                    let markAsDrankAlert = UIAlertController.init(title: alertTitle, message: message, preferredStyle:.alert)

                    markAsDrankAlert.addAction(UIAlertAction.init(title: okBtn, style: .default) { (UIAlertAction) -> Void in
                        self.dismiss(animated: true, completion:{
                            DataServices.removeBottles(bottles: markAsDrank)
                        })
                    })

                    markAsDrankAlert.addAction(UIAlertAction.init(title: cancelBtn, style: .cancel, handler: nil))

                    present(markAsDrankAlert, animated: true, completion: nil)

                } else {
                    dismiss(animated: true, completion: nil)
                }

            } else {
                dismiss(animated: true, completion: nil)
            }
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
                         NSAttributedString.Key.foregroundColor: UIColor.black])
        )
        
        attributedText.append(NSAttributedString(
            string: passedValue.locale + "\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.black])
        )
        
        attributedText.append(NSAttributedString(
            string: "Drinking Window: " + passedValue.drinkBy + "\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                         NSAttributedString.Key.foregroundColor: UIColor.black])
        )
                
        wineLabel.attributedText = attributedText
    }
    
    private func getTotalBottles()  -> String {
        let singularBottle = NSLocalizedString("singularBottle", comment: "bottle remaining")
        let pluralBottle = NSLocalizedString("pluralBottle", comment: "bottles remaining")
        let totalBottles = wineBins.count
        let bottleString = (totalBottles > 1) ? pluralBottle : singularBottle
        
        return String(totalBottles) + bottleString
    }

}

extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension WineDetailViewController : BinCellDelegate {
    func didTapStepper(direction: String){
        let singularBottle = NSLocalizedString("singularBottle", comment: "bottle remaining")
        let pluralBottle = NSLocalizedString("pluralBottle", comment: "bottles remaining")
        let minus = "minus" as String
        let plus = "plus" as String
        
        var count = 0
        
        let number = Int.parse(from: inventoryFooter.text!)
        if (direction == minus){
            count = number! - 1
        }
        if (direction == plus){
            count = number! + 1
        }
        let bottleString = (count == 1) ? singularBottle : pluralBottle

        inventoryFooter.text = String(count) + bottleString
    }
}
