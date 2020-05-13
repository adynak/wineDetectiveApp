//
//  BinTableViewCell.swift
//  wineBinsTableView
//
//  Created by adynak on 12/20/18.
//  Copyright © 2018 adynak. All rights reserved.
//

import UIKit


class AddTableViewCell : UITableViewCell {
    
    var bin:String! {
        didSet {
//            guard let binItem = bin else {return}
            
//            if let binName = binItem.binName {
                binNameLabel.text = bin
//            }
            
         }
    }
    
    let binNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(binNameLabel)
    
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10),
            containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10),
            containerView.heightAnchor.constraint(equalToConstant:40)
        ])
        
        NSLayoutConstraint.activate([
            binNameLabel.topAnchor.constraint(equalTo:containerView.topAnchor),
            binNameLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor),
            binNameLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
