//
//  SettingsLauncher.swift
//  wineApp
//
//  Created by adynak on 6/12/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject{
    
    let blackView = UIView()
    
    func showSettings(){
        
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor =  UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
            })
        }

    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
                       self.blackView.alpha = 0
        })
    }

    override init() {
        super.init()
    }
}
