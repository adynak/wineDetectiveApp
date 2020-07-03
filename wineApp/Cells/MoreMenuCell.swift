//
//  SettingsCell.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit

var switchIndex: Int = -1

class MoreMenuCell: UITableViewCell {
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else {return}
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }
    
    lazy var switchControl: UISwitch = {
        let sc = UISwitch()
        sc.isOn = true
        sc.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return sc
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        switchIndex += 1
        addSubview(switchControl)
        switchControl.tag = switchIndex
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSwitchAction(sender: UISwitch){
        if sender.isOn{
            print("SwitchOn \(sender.tag)")
        } else {
            print("SwitchOff \(sender.tag)")
        }
        
    }
    
}
