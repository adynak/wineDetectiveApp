//
//  RemoveBottlesController.swift
//  wineApp
//
//  Created by adynak on 5/25/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

class RemoveBottlesController :UITableViewController {
    
    var passedValues = [Level2]()

    
//    lazy var loginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(r:80, g:102, b:144)
//        button.setTitle("Remove", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//        button.isEnabled = true
//        button.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 20)
//        return button
//    }()
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let view = UIView()
        view.backgroundColor = .white
        
        // Create UIButton
        let myButton = UIButton(type: .system)
        
        // Position Button
        myButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        // Set text on button
        myButton.setTitle("Tap me", for: .normal)
        myButton.setTitle("Pressed + Hold", for: .highlighted)
        
        // Set button action
         myButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        view.addSubview(myButton)
        self.view = view
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        print("Button tapped")
        dismiss(animated: true, completion: nil)
//        let someview = ReconcileViewController()
//        present(someview, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)



    }

}
