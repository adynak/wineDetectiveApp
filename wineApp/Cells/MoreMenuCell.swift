//
//  SettingsCell.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit

class MoreMenuCell: UITableViewCell {
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else {return}            
            textLabel?.text = "" + sectionType.description
            
            textLabel?.translatesAutoresizingMaskIntoConstraints = false
            textLabel?.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
            textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
            switchControl.tag = sectionType.switchNumber
            
            switch sectionType.switchNumber{
            case 3:
                if UserDefaults.standard.getShowBarcode(){
                    switchControl.isOn = true
                } else {
                    switchControl.isOn = false
                }
            case 4:
                if UserDefaults.standard.getShowPages(){
                    switchControl.isOn = true
                } else {
                    switchControl.isOn = false
                }
            default:
                switchControl.isOn = false
            }
            
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    lazy var switchControl: UISwitch = {
        let sc = UISwitch()
        sc.onTintColor = switchOnColor
        sc.tintColor = switchOffColor
        sc.backgroundColor = switchOffColor
        sc.layer.cornerRadius = 16
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return sc
    }()
    
    let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
//        imageView.layer.backgroundColor = UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        addSubview(moreImageView)
        moreImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        moreImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        moreImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        moreImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSwitchAction(sender: UISwitch){
        let showBarcode: Int = 3
        let showPages: Int = 4
        if sender.isOn{
            print("SwitchOn \(sender.tag)")
            if sender.tag == showBarcode {
                UserDefaults.standard.set(true, forKey: "showBarcode")
            }
            if sender.tag == showPages {
                UserDefaults.standard.set(true, forKey: "showPages")
            }
        } else {
            print("SwitchOff \(sender.tag)")
            if sender.tag == showBarcode {
                UserDefaults.standard.set(false, forKey: "showBarcode")
            }
            if sender.tag == showPages {
                UserDefaults.standard.set(false, forKey: "showPages")
            }
        }
        
    }
    
}
