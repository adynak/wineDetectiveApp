//
//  Colors.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

let barTintColor =                UIColor(r: 61,  g:  91, b: 151)
let buttonTintColor =             UIColor(r: 266, g: 255, b: 255)
let foregroundColor =             UIColor(r: 266, g: 255, b: 255)
let productNameColor =            UIColor(r: 80,  g: 102, b: 144)
let placeholderColor =            UIColor(r: 80,  g: 102, b: 144)
let loginButtonColor =            UIColor(r: 80,  g: 102, b: 144)
let spinnerBoxColor =             UIColor(r: 80,  g: 102, b: 144)
let moreViewBackgroundColor =     UIColor(r: 212, g: 212, b: 219)
let tableStripeOdd =              UIColor(r: 184, g: 206, b: 249)
let tableStripeEven =             UIColor(r: 202, g: 227, b: 255)
let tableStripeWhite =            UIColor(r: 255, g: 255, b: 255)
let tableStripeGray =             UIColor(r: 240, g: 240, b: 240)
let storageLabelBackgroundColor = UIColor(r: 202, g: 227, b: 255)
let viewBackgroundColor =         UIColor(r: 255, g: 255, b: 255)
let switchOnColor =               UIColor(r: 52,  g: 199, b:  89)
let switchOffColor =              UIColor(r: 255, g:  91, b: 110)
let drinkByMenuBackground =       UIColor(r: 209, g: 209, b: 209)
let notNowButton =                UIColor(r:  94, g: 215, b: 206)
let unDrinkButton =               UIColor(r: 167, g: 148, b: 240)

//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
