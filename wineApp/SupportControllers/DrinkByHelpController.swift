//
//  DrinkByHelpController.swift
//  wineApp
//
//  Created by adynak on 6/14/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

class DrinkByHelpController: UIViewController{
        
    let helpLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("drinkByHelpText",
                                       comment: "Drinkability Help")
        label.numberOfLines = 20
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        navigationItem.title = NSLocalizedString("drinkByHelp",
                                                 comment: "Drinkability Help")
        view.backgroundColor = .white
    
        view.addSubview(helpLabel)

        NSLayoutConstraint.activate([
          helpLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
          helpLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
          helpLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)])
        

    }
}
