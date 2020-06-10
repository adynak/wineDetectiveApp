//
//  Loading Spinner.swift
//  wineApp
//
//  Created by adynak on 6/10/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit
var boxView = UIView()

extension UIViewController{
    
    func showSpinner(localizedText: String){
        
        let loadingView: UIView = {
            let v =  UIView()
            v.frame = CGRect(x: 0, y: 0, width: 180, height: 340)
            v.tag = 19
            v.backgroundColor = .white
            v.center.x = view.center.x
            v.center.y = view.center.y - 100
            return v
        }()

        let logo: UIImageView = {
            let image = UIImage(named: "logo")
            let iv = UIImageView(image: image)
            iv.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
            return iv
        }()

        let box: UIView = {
            let b =  UIView()
            b.frame = CGRect(x: 0, y: 200, width: 180, height: 100)
            b.backgroundColor = UIColor(r:80, g:102, b:144)
            b.alpha = 0.8
            b.layer.cornerRadius = 10
            return b
        }()
        
        let spinner: UIActivityIndicatorView = {
            let s = UIActivityIndicatorView()
            s.style = .large
            s.color = .black
            s.center.x = box.center.x + 5
            s.center.y = box.center.y - 20
            s.startAnimating()
            return s
        }()
        
        let text:UILabel = {
            let l = UILabel()
            l.frame = CGRect(x: 0, y: 0, width: 180, height: 30)
            l.textAlignment = .center
            l.layer.borderWidth = 0
            l.textColor = .white
            l.text = localizedText
            l.center.x = box.center.x
            l.center.y = box.center.y + 20
            return l
        }()
                
        loadingView.addSubview(logo)
        loadingView.addSubview(box)
        loadingView.addSubview(spinner)
        loadingView.addSubview(text)

        logo.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        
        view.addSubview(loadingView)

        
    }
    
    func hideSpinner(){
        if let subview = self.view.viewWithTag(19) {
        subview.removeFromSuperview()
        }
    }
    
}

