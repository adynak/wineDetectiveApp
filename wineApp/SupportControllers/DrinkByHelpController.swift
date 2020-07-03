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
        label.text = "\nThe Ready to Drink (a.k.a. Drinkability) report orders the wines in the cellar by an index number which shows whether a wine is being consumed faster or slower than a rate implied by the drinking window.\n\nThe drinkability report actually allows you to choose a global algorithm for all of the wines, but by default the report actually pre-defines different algorithms for different categories of wines.\n\nChoose one of these algorithms.\n\nThe default is Availability."
        label.numberOfLines = 20
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        navigationItem.title = "Drink By Help"
        view.backgroundColor = .white
    
        view.addSubview(helpLabel)

        NSLayoutConstraint.activate([
          helpLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
          helpLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
          helpLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)])
        

    }
}
