//
//  Extensions.swift
//  audible
//
//  Created by Brian Voong on 9/17/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

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
        
        let logo: UIImageView = {
            let image = UIImage(named: "logo")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: view.center.x - 70, y: view.center.y - 268, width: 160, height: 160)
            return imageView
        }()

        let boxView: UIView = {
            let box =  UIView()
            box.frame = CGRect(x: view.frame.midX - 90, y: view.frame.midY - 65, width: 180, height: 100)
            box.backgroundColor = UIColor(r:80, g:102, b:144)
            box.alpha = 0.8
            box.layer.cornerRadius = 10
            return box
        }()
        
        let text:UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 60, width: 180, height: 30)
            label.textAlignment = .center
            label.backgroundColor = UIColor(r:80, g:102, b:144)
            label.textColor = .white
            label.text = localizedText
            return label
        }()
        
        let spinner: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView()
            view.style = .large
            view.color = .black
            view.center = boxView.center
            view.frame = CGRect(x: 70, y: 10, width: 50, height: 50)
            view.startAnimating()
            return view
        }()
        
        self.view.addSubview(logo)
        boxView.addSubview(spinner)
        boxView.addSubview(text)
        
        view.addSubview(boxView)

        
    }
    
    func hideSpinner(){
        boxView.removeFromSuperview()
    }
}

