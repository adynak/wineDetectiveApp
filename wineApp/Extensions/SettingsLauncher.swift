//
//  SettingsLauncher.swift
//  wineApp
//
//  Created by adynak on 6/12/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit


class Setting: NSObject{
    let name: String
    let imageName: String
    let isSelected: Bool
    
    init(name: String, imageName: String, isSelected: Bool){
        self.name = name
        self.imageName = imageName
        self.isSelected = false
    }

}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let blackView = UIView()
    let cellID = "cellID"
    let cellHeight: CGFloat = 50
    let settings: [Setting] = {
        return [Setting(name: "Availability (Default)", imageName: "settings", isSelected: true),
        Setting(name: "Linear", imageName: "settings", isSelected: false),
        Setting(name: "Standard Bell (Red Wines)", imageName: "settings", isSelected: false),
        Setting(name: "Early Bell (Dry White Wines)", imageName: "settings", isSelected: false),
        Setting(name: "Late Bell (Bordeaux, Red Northern Rhône and Rioja)", imageName: "settings", isSelected: false),
        Setting(name: "Fast Maturing (All Rosé, Beaujolais, Moscato d'Asti)", imageName: "settings", isSelected: false),
        Setting(name: "Twin Peak (Red Southern Rhône, White Northern Rhône, White German)", imageName: "settings", isSelected: false),
        Setting(name: "Drinkability Help", imageName: "settings", isSelected: false),
        Setting(name: "Cancel", imageName: "settings", isSelected: false)]
        
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
     }()
    
    var homeController: DrinkByViewController?
    
    func showSetting(){
        
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor =  UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(settings.count + 1) * cellHeight
            let y = window.frame.height - height

            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: height)
            }, completion: nil)
            
        }

    }
    
    @objc func handleDismiss(setting: Setting){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow{
                    self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
        }, completion: { finished in
            if (type(of: setting as Any) != type(of: UITapGestureRecognizer())) && (setting.name == "Drinkability Help") {
                self.homeController?.showControllerForSetting(setting: setting)
            }
        })

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
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
        
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellID)
    }
}
