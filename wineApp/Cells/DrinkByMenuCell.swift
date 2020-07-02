//
//  DrinkByMenuCell.swift
//  wineApp
//
//  Created by adynak on 6/12/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class DrinkByMenuCell: BaseCell {
    
    override var isHighlighted: Bool{
        
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .black
//            iconImageView.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    var setting: Setting?{
        didSet {
            nameLabel.text = setting?.name
//            if let imageName = setting?.imageName{
//                iconImageView.image = UIImage(named: imageName)
//                iconImageView.tintColor = .darkGray
//            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settings")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        addSubview(nameLabel)
//        addSubview(iconImageView)

//        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView,nameLabel)
        addConstraintsWithFormat(format: "V:|-2-[v0(40)]|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: nameLabel)
//        addConstraintsWithFormat(format: "V:|[v0(30)]|", views: iconImageView)
        
//        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        
    }
}
