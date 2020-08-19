//
//  TableViewController.swift
//  IOSActionsTableViewTutorial
//
//  Created by Arthur Knopper on 25/02/2019.
//  Copyright © 2019 Arthur Knopper. All rights reserved.
//

import UIKit
import CoreData


class SyncViewController: UITableViewController {
    var apps = ["Minecraft","Facebook","Tweetbot","Instagram"]
    var markAsDrank = [DrillLevel2]()
    
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(TableCell.self, forCellReuseIdentifier: cellID)

    }
    
    private func setupNavigationBar(){
        let title = NSLocalizedString("titleSync", comment: "sync title: Inventory Out Of Sync")
        let subTitle = NSLocalizedString("titleSyncSubTitle", comment: "sync subtitle: Inventory Out Of Sync")
        
        navigationItem.titleView = DataServices.setupTitleView(title: title, subTitle: subTitle)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("buttonCancel", comment: "cancel button"),
            style: .plain,
            target: self,
            action: #selector(syncCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: NSLocalizedString("drinkByNavTitleHelp", comment: "drink by nav title Available"),
        style: .plain,
        target: self,
        action: #selector(syncHelp))
    }

    @objc func syncCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func syncHelp(){
        let alertTitle = NSLocalizedString("titleSync", comment: "sync title: Inventory Out Of Sync")
        var alertMessage = NSLocalizedString("syncMessage", comment: "what to do to fix sync condition")
        
        let bottleSingular = NSLocalizedString("singularThis", comment: "this wine")
        let pluralBottle = NSLocalizedString("pluralThese", comment: "these wines")
        let bottleString = (markAsDrank.count == 1) ? bottleSingular : pluralBottle
        
        alertMessage = alertMessage.replacingOccurrences(of: "%1", with: bottleString)

        
        let alertOk = NSLocalizedString("alertTextHelp", comment: "alert button text: Help")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: alertOk, style: .default, handler: nil))

        self.present(alert, animated: true)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markAsDrank.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var barcode: String = ""
        
        let colorOdd = tableStripeOdd
        let colorEven = tableStripeEven
        
        let vintage = markAsDrank[indexPath.row].vintage
        let varietal = markAsDrank[indexPath.row].varietal
        if UserDefaults.standard.getShowBarcode() {
            barcode = "(\(markAsDrank[indexPath.row].barcode!.digits))"
        }
        let producer = markAsDrank[indexPath.row].producer
        let locationAndBin = NSLocalizedString("labelLocation", comment: "label for location") + ": \(markAsDrank[indexPath.row].location!) \(markAsDrank[indexPath.row].bin!)"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "\(vintage!) \(producer!) \(varietal!)"
        cell.detailTextLabel?.text = "\(locationAndBin) \(barcode)"
        cell.backgroundColor = indexPath.row % 2 == 0 ? colorOdd : colorEven

        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in

            return self.makeContextMenu(for: indexPath)
        })
    }

    func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        
        let copyVPVTitle = NSLocalizedString("labelVPV", comment: "label: Vintage Producer Varietal")
        let copyBarcodeTitle = NSLocalizedString("labelBarcode", comment: "labelBarcode")
        let copyTitle = NSLocalizedString("labelClipboard", comment: "labelClipboard")

        let copyVPV = UIAction(title: copyVPVTitle) { [weak self] _ in
            guard let self = self else { return }
            let cell = self.tableView.cellForRow(at: indexPath)
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell?.textLabel?.text
        }
        
        let copyBarcode = UIAction(title: copyBarcodeTitle) { [weak self] _ in
            guard let self = self else { return }
            let cell = self.tableView.cellForRow(at: indexPath)
            let pasteboard = UIPasteboard.general
            let detailText = cell?.detailTextLabel?.text
            let textArray = detailText!.components(separatedBy: " ")
            let barcode = textArray.last?.digits
            pasteboard.string = barcode
        }

        return UIMenu(title: copyTitle, children: [copyVPV,copyBarcode])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)-> UISwipeActionsConfiguration? {
                
        let notNowTitle = NSLocalizedString("buttonSyncNotNow", comment: "sync: Not Now")
        
        let unDrinkTitle = NSLocalizedString("buttonSyncUnDrink", comment: "sync: return to inventory (Un-Drink)")
            
        let unDrinkAction = UIContextualAction(style: .normal, title: unDrinkTitle) { (action, view, completionHandler) in
            self.deleteFromCoreData(indexPath: indexPath, tableView: tableView)
            completionHandler(true)
        }
        unDrinkAction.backgroundColor = unDrinkButton

        let notNowAction = UIContextualAction(style: .destructive, title: notNowTitle) { (action, view, completionHandler) in
            completionHandler(true)
        }
        notNowAction.backgroundColor = notNowButton
            
        let configuration = UISwipeActionsConfiguration(actions: [notNowAction, unDrinkAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
    
    func deleteFromCoreData(indexPath: IndexPath, tableView: UITableView){
        self.apps.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
        
}
