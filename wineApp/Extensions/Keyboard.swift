//
//  Keyboard.swift
//  wineApp
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
        
    func addDoneButtonOnKeyboard()
    {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)

        let doneToolbar: UIToolbar = {
            let tb = UIToolbar()
            tb.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
            tb.sizeToFit()
            tb.items = [flexSpace,doneButton]
            return tb
        }()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
