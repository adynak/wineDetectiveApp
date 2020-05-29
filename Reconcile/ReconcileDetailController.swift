//
//  ViewController.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 9/25/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class ReconcileViewDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource{
        
    var tableContainerTopAnchor:CGFloat = 200.0
    var tableContainerHeightAnchor:CGFloat = UIScreen.main.bounds.height - 327
    let tableRowHeight:CGFloat = 50
    let sortBins:Bool = true
    
    var cellID = "cellID123"
    var wineBins = [Level2]()
    
    var cells = [ReconcileTableViewCell]() //initialize array at class level

    var passedValue = wineDetail()
    
    let storageLabel: UITextView = {
        let tv = UITextView()
        tv.text = "Location and Bin:"
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        wineBins = passedValue.bottles!

        view.backgroundColor = UIColor(r:202, g:227, b:255)
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
        storageLabel.text = "Location and Bin: \(passedValue.location!) \(passedValue.bin!)\nBottles: \(passedValue.bottleCount)"
        
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
        wineBinsTableView.register(ReconcileTableViewCell.self, forCellReuseIdentifier: cellID)
        wineBinsTableView.rowHeight = tableRowHeight
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineBins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // want to stripe the table's rows?
        let colorOdd = UIColor(r:255, g:255, b:255) //white
        let colorEven = UIColor(r:240, g:240, b:240)
        
        let vintage = wineBins[indexPath.row].vintage
        let producer = wineBins[indexPath.row].producer
        let varietal = wineBins[indexPath.row].varietal
        let iWine = wineBins[indexPath.row].iWine
        let barcode = wineBins[indexPath.row].barcode
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ReconcileTableViewCell
        
        cell.bin = Level2(producer: producer, varietal: varietal, vintage: vintage, iWine: iWine, barcode: barcode)
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        cell.delegate = self
        
        if(!cells.contains(cell)){
            self.cells.append(cell)
        }

        return cell
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Reconcile"

        
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
        var markAsDrank = [Level2]()

        if (sender.title == "Save"){
            for cell in cells {
                if let bottles = Int.parse(from: cell.bottleCountLabel.text!) {
                    if bottles == 0{
                        markAsDrank.append(Level2(
                            producer: cell.producerLabel.text!,
                            varietal: cell.varietalLabel.text!,
                            vintage: cell.vintageLabel.text!,
                            iWine: cell.iWineLabel.text!,
                            barcode: cell.barcodeLabel.text!))
                    }
                }
            }
            if markAsDrank.count > 0{

                let message = buildRemoveMessage(bottles: markAsDrank)

                let logOutAlert = UIAlertController.init(title: "Remove Bottles", message: message, preferredStyle:.alert)

                logOutAlert.addAction(UIAlertAction.init(title: "Yes", style: .default) { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion:{
                        DataServices.removeBottles(bottles: markAsDrank)
                    })
                })

                logOutAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

                self.present(logOutAlert, animated: true, completion: nil)

            } else {
                dismiss(animated: true, completion: nil)
            }

        } else {
            dismiss(animated: true, completion: nil)
        }
    }
        
    private func getTotalBottles()  -> String {
        let totalBottles = wineBins.count
        let bottleString = (totalBottles > 1) ? " bottles remaining" : " bottle remaining"
        
        return String(totalBottles) + bottleString
    }
    
    func buildRemoveMessage(bottles: [Level2])->String{
        var message: String = ""
        for bottle in bottles{
            message += "\(bottle.vintage!) \(bottle.producer!)\n \(bottle.varietal!)\n\n"
        }
        message += "Are you sure?"
        return message
    }

}

extension ReconcileViewDetailController : ReconcileBinCellDelegate {
    func didTapStepper(direction: String){
        let minus = "minus" as String
        let plus = "plus" as String
        
        var count = 0
        
        let number = Int.parse(from: inventoryFooter.text!)
        if (direction == minus){
            count = number! - 1
        }
        if (direction == plus){
            count = number! + 1
//            let addWineController = AddWineController()
//            addWineController.passedValue = passedValue
//            let navController = UINavigationController(rootViewController: addWineController)
//            present(navController, animated: true, completion: nil)
        }
        let bottleString = (count == 1) ? " bottle remaining" : " bottles remaining"

        inventoryFooter.text = String(count) + bottleString
    }
}
