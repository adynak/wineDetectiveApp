//
//  DrinkByMenuLauncher.swift
//  wineApp
//
//  Created by adynak on 6/12/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

class DrinkByMenuItem: NSObject{
    let name: String
    let imageName: String
    let isSelected: Bool
    let drinkByMenuCode: String
    let drinkByNavTitle: String
    
    init(name: String, imageName: String, isSelected: Bool, drinkByMenuCode: String, drinkByNavTitle: String){
        self.name = name
        self.imageName = imageName
        self.isSelected = false
        self.drinkByMenuCode = drinkByMenuCode
        self.drinkByNavTitle = drinkByNavTitle
    }

}

class DrinkByMenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let backgroundView = UIView()
    let cellID = "cellID"
    let cellHeight: CGFloat = 35
    let drinkByMenuItems: [DrinkByMenuItem] = {
        return [
            DrinkByMenuItem(name: NSLocalizedString("drinkByDefault", comment: "Available (default)"),
                    imageName: "settings",
                    isSelected: true,
                    drinkByMenuCode: "Available",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleAvailable", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByLinear", comment: "Linear"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Linear",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleLinear", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByStandardBell", comment: "Standard Bell (Red Wines)"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Bell",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleStandardBell", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByEarlyBell", comment: "Early Bell (Dry White Wines)"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Early",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleEarlyBell", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByLateBell", comment: "Late Bell (Red Bordeaux, Red Northern Rhone and Rioja)"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Late",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleLateBell", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByFast", comment: "Fast Maturing (Rosé, Beaujolais, Moscato d'Asti)"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Fast",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleFastMaturing", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByTwinPeak", comment: "Twin Peak (Red Southern Rhône, White Northern Rhône, White German)"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "TwinPeak",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleTwinPeak", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("reportMissingDates", comment: "Wines Missing A Drinking Window"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Missing",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleMissing", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByHelp", comment: "Drinkability Help"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Help",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleHelp", comment: "drink by nav title Available")),
            DrinkByMenuItem(name: NSLocalizedString("drinkByCancel", comment: "Cancel"),
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Cancel",
                    drinkByNavTitle: NSLocalizedString("drinkByNavTitleCancel", comment: "drink by nav title Available"))
        ]
        
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 10
        return cv
     }()
    
    var homeController: DrinkByViewController?
    
    func showDrinkByMenu(){
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {

            backgroundView.backgroundColor =  UIColor(white: 0, alpha: 0.5)
            
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(backgroundView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(drinkByMenuItems.count) * cellHeight + 10
            let y = window.frame.height - height - 20

            collectionView.frame = CGRect(x: 20, y: window.frame.height - 50, width: window.frame.width - 40, height: height)
            
            backgroundView.frame = window.frame
            backgroundView.alpha = 0
            
            UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 1
                self.collectionView.frame = CGRect(x: 20, y: y - 50, width: self.collectionView.frame.width, height: height)
            }, completion: nil)
            
        }

    }
    
    @objc func handleDismiss(drinkByMenuItem: DrinkByMenuItem){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 0
//                if let window = UIApplication.shared.keyWindow {
                if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
        }, completion: { finished in
            if (type(of: drinkByMenuItem as Any) != type(of: UITapGestureRecognizer())){
                if (drinkByMenuItem.drinkByMenuCode == "Help") {
                    self.homeController?.showControllerForDrinkByMenu(drinkByMenuItem: drinkByMenuItem)
                } else {
                NotificationCenter.default.post(name: Notification.Name("changeDrinkBySort"),
                                                object: nil,
                                                userInfo:[
                                                    "drinkByMenuCode": drinkByMenuItem.drinkByMenuCode,
                                                    "key1": 1234])
                }
            }
        })

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinkByMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DrinkByMenuCell
                
        if indexPath.row == 0 {
            cell.backgroundColor = drinkByMenuBackground
            currentSelected = indexPath.row
            previousSelected = indexPath
        } else {
            cell.backgroundColor = .white
        }
        
        let drinkByMenuItem = drinkByMenuItems[indexPath.item]
        cell.drinkByMenuItem = drinkByMenuItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var previousSelected : IndexPath?
    var currentSelected : Int?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let drinkByMenuItem = self.drinkByMenuItems[indexPath.item]
        let menuSelection = drinkByMenuItem.name
        var changeCellBackgroundColor: Bool = false
        
        switch menuSelection {
            case NSLocalizedString("drinkByCancel", comment: "Cancel"),
                 NSLocalizedString("drinkByHelp", comment: "Drinkability Help"):
                changeCellBackgroundColor = false
            default:
                changeCellBackgroundColor = true
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        if previousSelected != nil{
            if changeCellBackgroundColor{
                collectionView.cellForItem(at: previousSelected!)!.backgroundColor = .white
                cell!.backgroundColor = drinkByMenuBackground
                currentSelected = indexPath.row
                previousSelected = indexPath
            }
        } else {
            if changeCellBackgroundColor{
                cell!.backgroundColor = drinkByMenuBackground
                currentSelected = indexPath.row
                previousSelected = indexPath
            }
        }
        
        
        handleDismiss(drinkByMenuItem: drinkByMenuItem)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DrinkByMenuCell.self, forCellWithReuseIdentifier: cellID)
    }
}
