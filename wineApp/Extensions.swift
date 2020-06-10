//
//  Extensions.swift
//  audible
//
//  Created by Brian Voong on 9/17/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
}

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

