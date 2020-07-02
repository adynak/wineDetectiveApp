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
    
    init(name: String, imageName: String, isSelected: Bool, drinkByMenuCode: String){
        self.name = name
        self.imageName = imageName
        self.isSelected = false
        self.drinkByMenuCode = drinkByMenuCode
    }

}

class DrinkByMenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let blackView = UIView()
    let cellID = "cellID"
    let cellHeight: CGFloat = 35
    let drinkByMenuItems: [DrinkByMenuItem] = {
        return [
            DrinkByMenuItem(name: "Availability (Default)",
                    imageName: "settings",
                    isSelected: true,
                    drinkByMenuCode: "Available"),
            DrinkByMenuItem(name: "Linear",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Linear"),
            DrinkByMenuItem(name: "Standard Bell (Red Wines)",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Bell"),
            DrinkByMenuItem(name: "Early Bell (Dry White Wines)",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Early"),
            DrinkByMenuItem(name: "Late Bell (Red Bordeaux, Red Northern Rhône and Rioja)",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Late"),
            DrinkByMenuItem(name: "Fast Maturing (All Rosé, Beaujolais, Moscato d'Asti)",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Fast"),
            DrinkByMenuItem(name: "Twin Peak (Red Southern Rhône, White Northern Rhône, White German)",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "TwinPeak"),
            DrinkByMenuItem(name: "Wines Missing A Drinking Window",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Missing"),
            DrinkByMenuItem(name: "Drinkability Help",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Help"),
            DrinkByMenuItem(name: "Cancel",
                    imageName: "settings",
                    isSelected: false,
                    drinkByMenuCode: "Cancel")
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
    
    func showSetting(){
        
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor =  UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(drinkByMenuItems.count) * cellHeight + 10
            let y = window.frame.height - height - 20

            collectionView.frame = CGRect(x: 20, y: window.frame.height - 50, width: window.frame.width - 40, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 20, y: y - 50, width: self.collectionView.frame.width, height: height)
            }, completion: nil)
            
        }

    }
    
    @objc func handleDismiss(setting: DrinkByMenuItem){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow{
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
        }, completion: { finished in
            if (type(of: setting as Any) != type(of: UITapGestureRecognizer())){
                if (setting.drinkByMenuCode == "Help") {
                    self.homeController?.showControllerForDrinkByMenu(setting: setting)
                    print(setting.drinkByMenuCode)
                } else {
                NotificationCenter.default.post(name: Notification.Name("changeDrinkBySort"),
                                                object: nil,
                                                userInfo:[
                                                    "drinkByMenuCode": setting.drinkByMenuCode,
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
        let setting = drinkByMenuItems[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.drinkByMenuItems[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DrinkByMenuCell.self, forCellWithReuseIdentifier: cellID)
    }
}
