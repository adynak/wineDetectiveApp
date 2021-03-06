//
//  DrillDownDetailViewController.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class DrillDownDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate {
        
    var tableContainerTopAnchor:CGFloat = 200.0
    var tableContainerHeightAnchor:CGFloat = UIScreen.main.bounds.height - 327
//    let tableRowHeight:CGFloat = 60
    let sortBins:Bool = true
    
    let cellID = "cellIdz"
    var wineBins = [DrillLevel2]()
    
    var cells = [DrillDownTableViewCell]()

    var passedValue = WineDetail()
    
    let storageLabel: UITextView = {
        // something about the order of these configs is important
        let tv = UITextView()
        tv.text = NSLocalizedString("labelLocationAndBin", comment: "textfield label: Location and Bin: similar to a storage room and a filing cabinet in that room")
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = storageLabelBackgroundColor
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.textContainer.lineFragmentPadding = 0
        tv.textContainer.maximumNumberOfLines = 2
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
    
    let footerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.backgroundColor = storageLabelBackgroundColor
        return v
    }()
        
    lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = loginButtonColor
        button.setTitle(NSLocalizedString("drinkAllBottles", comment: "button text: drink all bottles"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(toggleDrinkAll), for: .touchUpInside)
        button.isEnabled = true
        button.titleLabel!.font = UIFont(name: "Verdana", size: 14)
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        return button
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
        navigationController?.presentationController?.delegate = self
        
        wineBins = passedValue.bottles!

        view.backgroundColor = storageLabelBackgroundColor
        view.addSubview(storageLabel)
        view.addSubview(tableContainer)
        tableContainer.addSubview(wineBinsTableView)
        view.addSubview(footerView)
        footerView.addSubview(inventoryFooter)
        footerView.addSubview(toggleButton)
        toggleButton.sizeToFit()

        setupNavigationBar()
        setupWineLabelLayout()
        setupFooterViewLayout()
        setupInventoryFooterLayout()
        setupToggleButtonLayout()
        setupWineBinsTableViewLayout()
        
//        toggleButton.addTarget(self, action: #selector(toggleDrinkAll), for: .touchUpInside)

    }
    
    var hasChanges: Bool {
        return Int.parse(from:inventoryFooter.text) != Int.parse(from:passedValue.bottleCount)
    }
    
    override func viewWillLayoutSubviews() {
        navigationItem.rightBarButtonItem?.isEnabled = hasChanges
        isModalInPresentation = hasChanges
    }
    
    func setupInventoryFooterLayout(){
        inventoryFooter.text = getTotalBottles()
        NSLayoutConstraint.activate([
            inventoryFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inventoryFooter.heightAnchor.constraint(equalToConstant: 40),
            inventoryFooter.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant : 6),
        ])
    }
    
    func setupToggleButtonLayout(){
        NSLayoutConstraint.activate([
            toggleButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            toggleButton.rightAnchor.constraint(equalTo: footerView.rightAnchor,constant: -12),
            toggleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupFooterViewLayout(){
        NSLayoutConstraint.activate([
            footerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            footerView.heightAnchor.constraint(equalToConstant: 40),
            footerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant : 0),
            footerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant : -0)
        ])
    }

    
    func setupWineLabelLayout(){
        let labelTopLine: String
        let labelBottomLine: String

        let bottles = NSLocalizedString("pluralBottle", comment: "plural of the word bottle")
        
        switch passedValue.viewName {
            case "producer":
                labelTopLine = passedValue.bottles![0].producer!
                labelBottomLine = passedValue.bottles![0].varietal!
            case "varietal":
                labelTopLine = passedValue.bottles![0].producer!
                labelBottomLine = passedValue.bottles![0].varietal!
            case "location":
                labelTopLine = " " + passedValue.bottles![0].location! + " " + passedValue.bottles![0].bin!
                labelBottomLine = "\(bottles): \(passedValue.bottleCount)"
            case "missing":
                labelTopLine = passedValue.bottles![0].producer!
                labelBottomLine = passedValue.bottles![0].varietal!
            case "search":
                labelTopLine = passedValue.bottles![0].producer!
                labelBottomLine = passedValue.bottles![0].varietal!
            case "drinkby":
                labelTopLine = passedValue.bottles![0].producer!
                labelBottomLine = passedValue.bottles![0].varietal!
            default:
                labelTopLine = ""
                labelBottomLine = ""
        }
        
        storageLabel.text = String(labelTopLine + "\n" + labelBottomLine)
        
        NSLayoutConstraint.activate([
            storageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            storageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant : 5.0),
            storageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            storageLabel.heightAnchor.constraint(equalToConstant: 44)
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
        wineBinsTableView.delegate = self
        wineBinsTableView.register(DrillDownTableViewCell.self, forCellReuseIdentifier: cellID)
        if UserDefaults.standard.getShowBarcode() {
            wineBinsTableView.rowHeight = CGFloat(76)
        } else {
            wineBinsTableView.rowHeight = CGFloat(62)
        }
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineBins.count
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in

            return self.makeContextMenu(for: indexPath, tableView: tableView)
        })
    }
    
    func makeContextMenu(for indexPath: IndexPath, tableView: UITableView) -> UIMenu {
        
        let copyVPVTitle = NSLocalizedString("labelVPV", comment: "button text: Vintage Producer Varietal")
        let copyBarcodeTitle = NSLocalizedString("labelBarcode", comment: "textfield label: Barcode")
        let copyTitle = NSLocalizedString("labelClipboard", comment: "button text: Copy To Clipboard")

        let copyVPV = UIAction(title: copyVPVTitle) { [weak self] _ in
            guard self != nil else { return }
            let cell = tableView.cellForRow(at: indexPath) as! DrillDownTableViewCell
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell.vpvLabel.text
        }
        
        let copyBarcode = UIAction(title: copyBarcodeTitle) { [weak self] _ in
            guard self != nil else { return }
            let cell = tableView.cellForRow(at: indexPath) as! DrillDownTableViewCell
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell.barcodeLabel.text?.digits
        }
        
        if UserDefaults.standard.getShowBarcode() {
            return UIMenu(title: copyTitle, children: [copyVPV,copyBarcode])
        } else {
            return UIMenu(title: copyTitle, children: [copyVPV])
        }
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
        let bottleCount = wineBins[indexPath.row].bottleCount
        var description = wineBins[indexPath.row].description
        if description == nil {
            description = passedValue.description
        }

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
                    endConsume: endConsume,
                    viewName: passedValue.viewName,
                    bottleCount: bottleCount,
                    description: description)
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven
        cell.delegate = self
        
        if(!cells.contains(cell)){
            cells.append(cell)
        }

        return cell
    }
            
    private func setupNavigationBar(){
        var mainTitle: String = ""
        var subTitle: String = ""

        switch passedValue.viewName {
            case "producer":
                subTitle = passedValue.topLeft!
                mainTitle = title!
                subTitle = ""
            case "varietal":
                subTitle = passedValue.topRight!
                mainTitle = title!
                subTitle = ""
            case "location":
                subTitle = "\(passedValue.topLeft!) \(passedValue.topRight!)"
                mainTitle = title!
                subTitle = ""
            case "missing":
                subTitle = passedValue.topLeft!
                mainTitle = title!
                subTitle = ""
            case "search":
                mainTitle = NSLocalizedString("titleSearch", comment: "navigation title: search")
                subTitle = title!
                if mainTitle == subTitle {
                    subTitle = ""
                } else {
                    subTitle = subTitle.quoted
                }
            case "drinkby":
                mainTitle = NSLocalizedString("titleDrinkBy", comment: "Navigation Bar menu title: Drink By.  This will display a list of wines sorted by when they should be consumed, from sooner to later.")
                subTitle = title!
                if mainTitle == subTitle {
                    subTitle = ""
                } else {
                    subTitle = subTitle.quoted
                }
            default:
                subTitle = ""
        }

        navigationItem.titleView = DataServices.setupTitleView(title: mainTitle, subTitle: subTitle)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("buttonCancel", comment: "cancel button"),
            style: .plain,
            target: self,
            action: #selector(cancelMarkDrank))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("buttonSave", comment: "button text: Save"),
            style: .plain,
            target: self,
            action: #selector(saveMarkDrank))
    }
    
    @objc func cancelMarkDrank() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleDrinkAll(sender: UIButton){
        sender.isSelected = !sender.isSelected
        
        let bottleSingular = NSLocalizedString("singularRemaining", comment: "when there is one bottle in inventory: Bottle Remaining")
        let pluralBottle = NSLocalizedString("pluralRemaining", comment: "when there are more than one bottle in inventory: Bottles Remaining")

        if sender.isSelected {
            sender.setTitle(NSLocalizedString("unDrinkAllBottles", comment: "button text: un-drink all bottles"), for: .normal)
            for (index,_) in wineBins.enumerated() {
                wineBins[index].bottleCount = 0
            }
            self.inventoryFooter.text = String(0) + pluralBottle
            self.wineBinsTableView.reloadData()
        } else {
            sender.setTitle(NSLocalizedString("drinkAllBottles", comment: "button text: drink all bottles"), for: .normal)
            for (index,_) in wineBins.enumerated() {
                wineBins[index].bottleCount = 1
            }
            let bottleString = (self.wineBins.count == 1) ? bottleSingular : pluralBottle
            self.inventoryFooter.text = String(self.wineBins.count) + bottleString
            self.wineBinsTableView.reloadData()
        }

    }
    
    @objc func saveMarkDrank(){
        self.confirmCancel(showingSave: true)
    }
    
    func buildMarkAsDrankList() -> [DrillLevel2]{
        var markAsDrank = [DrillLevel2]()

//        for cell in cells {
//            if let bottles = Int.parse(from: cell.bottleCountLabel.text!) {
//                if bottles == 0 {
//                    markAsDrank.append(DrillLevel2(
//                        producer: cell.producerLabel.text!,
//                        varietal: cell.locationAndBinLabel.text!,
//                        vintage: cell.vintageLabel.text!,
//                        iWine: cell.iWineLabel.text!,
//                        barcode: cell.barcodeLabel.text!,
//                        designation: cell.vintageAndDescriptionLabel.text,
//                        ava: cell.drinkByLabel.text))
//                }
//            }
//        }
        
        for row in wineBins {
            if row.bottleCount == 0 {
                let vpd = String("\(row.vintage!) \(row.producer!) \(row.designation!)")
                let va = String("\(row.varietal!) \(row.ava!)")
                markAsDrank.append(DrillLevel2(
                    producer: row.producer,
                    varietal: row.varietal,
                    vintage: row.vintage,
                    iWine: row.iWine,
                    barcode: row.barcode,
                    designation: vpd,
                    ava: va)
                )
            }
        }
        return markAsDrank
    }
        
    private func getTotalBottles()  -> String {
        let bottleSingular = NSLocalizedString("singularRemaining", comment: "when there is one bottle in inventory: Bottle Remaining")
        let pluralBottle = NSLocalizedString("pluralRemaining", comment: "when there are more than one bottle in inventory: Bottles Remaining")
        let totalBottles = wineBins.count
        let bottleString = (totalBottles > 1) ? pluralBottle : bottleSingular
        
        return String(totalBottles) + bottleString
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel(showingSave: true)
    }
    
    func confirmCancel(showingSave: Bool) {
        var markAsDrank = [DrillLevel2]()
        var message: String = ""

        markAsDrank = buildMarkAsDrankList()
        message = buildRemoveMessage(bottles: markAsDrank)
        
        let titleText = NSLocalizedString("alertTitleMarkAsDrank", comment: "alert title: mark this bottle as consumed")
        
        var drinkButtonText = NSLocalizedString("buttonDrink", comment: "button text: Remove %1 is bottleCount, %2 is singular/plural of bottle(s)")
        drinkButtonText = drinkButtonText.replacingOccurrences(of: "%1", with: String(markAsDrank.count))
        
        let plural = markAsDrank.count == 1 ? NSLocalizedString("singularBottle", comment: "singular for the word bottle") : NSLocalizedString("pluralBottle", comment: "plural of the word bottle")
        
        drinkButtonText = drinkButtonText.replacingOccurrences(of: "%2", with: plural)
        
        let alertTitle = "\(titleText)"
        let cancelBtnText = NSLocalizedString("buttonCancel", comment: "cancel button")
        let discardBtnText = NSLocalizedString("buttonDiscard", comment: "discard button")

        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.setMessageAlignment(.left)
        
        if showingSave {
            alert.addAction(UIAlertAction.init(title: drinkButtonText, style: .default) { (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion:{
                    DataServices.removeBottles(bottles: markAsDrank, writeCoreData: true)
                })
            })
        }
        
        alert.addAction(UIAlertAction.init(title: discardBtnText, style: .destructive) { (UIAlertAction) -> Void in
            for (index,cell) in self.cells.enumerated() {
                cell.bottleCountLabel.text = "1 \(NSLocalizedString("singularBottle", comment: "singular for the word bottle"))"
                cell.stepperView.tag = 1
                cell.stepperView.value = 1
                self.wineBins[index].bottleCount = 1
                self.toggleButton.setTitle(NSLocalizedString("drinkAllBottles", comment: "button text: drink all bottles"), for: .normal)
                self.toggleButton.isSelected = false
            }
            let bottleSingular = NSLocalizedString("singularRemaining", comment: "when there is one bottle in inventory: Bottle Remaining")
            let pluralBottle = NSLocalizedString("pluralRemaining", comment: "when there are more than one bottle in inventory: Bottles Remaining")
            let bottleString = (self.wineBins.count == 1) ? bottleSingular : pluralBottle

            self.inventoryFooter.text = String(self.wineBins.count) + bottleString
        })
        
        alert.addAction(UIAlertAction.init(title: cancelBtnText, style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion:nil)
        })
        
        alert.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
            alert.view.addConstraint(height)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        Alert.debugPrint(debugMessage: "WILL")
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        Alert.debugPrint(debugMessage: "DID")
        let showConfirmAlert = shouldShowConfirmAlert(cells: cells)

        if showConfirmAlert {
            confirmCancel(showingSave: true)
        }

    }
    
    func buildRemoveMessage(bottles: [DrillLevel2])->String{
        var message: String = ""
        var barcode: String = ""
        var index: Int = 0
        
        for bottle in bottles {
            if (index != 0){
                message += "\n\n"
            }
            index += 1
            if UserDefaults.standard.getShowBarcode() {
                barcode = "(\(bottle.barcode!.digits))"
            }
            if passedValue.viewName == "location"{
                message += "\(bottle.designation!)\n\(bottle.ava!) \(barcode)"
            } else {
                message += "\(bottle.designation!)\n\(bottle.varietal!) \(barcode)"
            }
        }
        return message
    }

    func shouldShowConfirmAlert(cells: [DrillDownTableViewCell]) -> Bool {
        let stepperCount = Int.parse(from:inventoryFooter.text)
        let bottleCount = cells.count
        if stepperCount == bottleCount {
            return false
        } else {
            return true
        }
    }
    
}

extension DrillDownDetailViewController : DrillDownStepperCellDelegate {
    
    func didTapStepper(direction: String, barcode: String){
        let bottleSingular = NSLocalizedString("singularRemaining", comment: "when there is one bottle in inventory: Bottle Remaining")
        let pluralBottle = NSLocalizedString("pluralRemaining", comment: "when there are more than one bottle in inventory: Bottles Remaining")
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
        let bottleString = (count == 1) ? bottleSingular : pluralBottle
                
        if let foo = self.wineBins.enumerated().first(where: {$0.element.barcode == barcode}) {
            if direction == plus {
                self.wineBins[foo.offset].bottleCount! += 1
            } else {
                self.wineBins[foo.offset].bottleCount! -= 1
            }
        } else {
           // item could not be found
        }

        inventoryFooter.text = String(count) + bottleString
    }
}
