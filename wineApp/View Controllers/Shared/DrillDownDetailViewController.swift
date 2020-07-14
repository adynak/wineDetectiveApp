//
//  DrillDownDetailViewController.swift
//  wineApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.//
//

import UIKit

class DrillDownDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
        
    var tableContainerTopAnchor:CGFloat = 200.0
    var tableContainerHeightAnchor:CGFloat = UIScreen.main.bounds.height - 327
//    let tableRowHeight:CGFloat = 60
    let sortBins:Bool = true
    
    let cellID = "cellId"
    var wineBins = [DrillLevel2]()
    
    var cells = [DrillDownTableViewCell]() //initialize array at class level

    var passedValue = wineDetail()
    
    let storageLabel: UITextView = {
        let tv = UITextView()
        tv.text = NSLocalizedString("locationAndBin", comment: "")
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
        tv.text = NSLocalizedString("totalBottles", comment: "")
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
        
        wineBins = passedValue.bottles!

        view.backgroundColor = storageLabelBackgroundColor
        view.addSubview(storageLabel)
        view.addSubview(tableContainer)
        tableContainer.addSubview(wineBinsTableView)
        view.addSubview(inventoryFooter)

        setupNavigationBar()
        setupWineLabelLayout()
        setupInventoryFooterLayout()
        setupWineBinsTableViewLayout()
        
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
        let bottles = NSLocalizedString("bottles", comment: "")
        storageLabel.text = "\(passedValue.topLeft!) \(passedValue.topRight!)\n\(bottles): \(passedValue.bottleCount)"
        
        NSLayoutConstraint.activate([
            storageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            storageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant : 5.0),
            storageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            storageLabel.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func setupWineBinsTableViewLayout(){
        tableContainer.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableContainer.topAnchor.constraint(equalTo:storageLabel.bottomAnchor, constant:10),
            tableContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant : 6),
            tableContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant : -6),
            tableContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110)
        ])
        
        NSLayoutConstraint.activate([
            wineBinsTableView.topAnchor.constraint(equalTo:tableContainer.topAnchor, constant: 5),
            wineBinsTableView.leadingAnchor.constraint(equalTo:tableContainer.leadingAnchor, constant: 5),
            wineBinsTableView.trailingAnchor.constraint(equalTo:tableContainer.trailingAnchor, constant: -5),
            wineBinsTableView.bottomAnchor.constraint(equalTo:tableContainer.bottomAnchor, constant: -5)
        ])
        
        wineBinsTableView.dataSource = self
        wineBinsTableView.register(DrillDownTableViewCell.self, forCellReuseIdentifier: cellID)
        if UserDefaults.standard.getShowBarcode() {
            wineBinsTableView.rowHeight = CGFloat(80)
        } else {
            wineBinsTableView.rowHeight = CGFloat(80)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineBins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // want to stripe the table's rows?
        let colorOdd = tableStripeWhite
        let colorEven = tableStripeGray
        
        let vintage = wineBins[indexPath.row].vintage
        let producer = wineBins[indexPath.row].producer
        let varietal = wineBins[indexPath.row].varietal
        let iWine = wineBins[indexPath.row].iWine
        let barcode = wineBins[indexPath.row].barcode
        
        let location = wineBins[indexPath.row].location
        let bin = wineBins[indexPath.row].bin
        
        let designation = wineBins[indexPath.row].designation
        let ava = wineBins[indexPath.row].ava
        let beginConsume = wineBins[indexPath.row].beginConsume
        let endConsume = wineBins[indexPath.row].endConsume
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DrillDownTableViewCell
        
        cell.bin = DrillLevel2(
                    producer: producer,
                    varietal: varietal,
                    vintage: vintage,
                    iWine: iWine,
                    location: location,
                    bin: bin,
                    barcode: barcode,
                    designation: designation,
                    ava: ava,
                    beginConsume: beginConsume,
                    endConsume: endConsume)
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        cell.delegate = self
        
        if(!cells.contains(cell)){
            self.cells.append(cell)
        }

        return cell
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = title

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title:   NSLocalizedString("cancel", comment: ""),
            style: .plain,
            target: self,
            action: #selector(addTapped))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title:   NSLocalizedString("save", comment: ""),
            style: .plain,
            target: self,
            action: #selector(addTapped))
    }
    
    @objc func addTapped(sender: UIBarButtonItem){
        var markAsDrank = [DrillLevel2]()

        if (sender.title == NSLocalizedString("save", comment: "")){
            for cell in cells {
                if let bottles = Int.parse(from: cell.bottleCountLabel.text!) {
                    if bottles == 0{
                        markAsDrank.append(DrillLevel2(
                            producer: cell.producerLabel.text!,
                            varietal: cell.locationAndBinLabel.text!,
                            vintage: cell.vintageLabel.text!,
                            iWine: cell.iWineLabel.text!,
                            barcode: cell.barcodeLabel.text!))
                    }
                }
            }
            if markAsDrank.count > 0{
                let alertTitle = NSLocalizedString("markAsDrankTitle", comment: "")
                let okBtn = NSLocalizedString("okBtn", comment: "")
                let cancelBtn = NSLocalizedString("cancelBtn", comment: "")
//                let message = buildRemoveMessage(bottles: markAsDrank)
                let message = ""

                let markAsDrankAlert = UIAlertController.init(title: alertTitle, message: message, preferredStyle:.alert)

                markAsDrankAlert.addAction(UIAlertAction.init(title: okBtn, style: .default) { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion:{
                        DataServices.removeDrillBottles(bottles: markAsDrank)
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
        
    private func getTotalBottles()  -> String {
        let singularBottle = NSLocalizedString("singularBottle", comment: "")
        let pluralBottle = NSLocalizedString("pluralBottle", comment: "")
        let totalBottles = wineBins.count
        let bottleString = (totalBottles > 1) ? pluralBottle : singularBottle
        
        return String(totalBottles) + bottleString
    }
    
    func buildRemoveMessage(bottles: [DrillLevel2])->String{
        let confirmBtn = NSLocalizedString("confirmBtn", comment: "")

        var message: String = ""
        for bottle in bottles{
            message += "\(bottle.vintage!) \(bottle.producer!)\n \(bottle.varietal!)\n\n"
        }
        message += confirmBtn
        return message
    }

}

extension DrillDownDetailViewController : DrillDownStepperCellDelegate {
    func didTapStepper(direction: String){
        let singularBottle = NSLocalizedString("singularBottle", comment: "")
        let pluralBottle = NSLocalizedString("pluralBottle", comment: "")
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
