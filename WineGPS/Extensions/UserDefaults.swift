//
//  UserDefaults.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case userName
        case userPword
        case showBarcode
        case showPages
        case rememberMe
        case iCloudAvailable
        case widgetVarietal
    }
    
    static func contains(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setUserName(value: String) {
        
        if let userDs = UserDefaults(suiteName: "group.adynak.wineGPS") {
            userDs.set(value as AnyObject, forKey: "username")
        }
        set(value, forKey: UserDefaultsKeys.userName.rawValue)
        synchronize()
    }
    
    func setUserPword(value: String) {
        
        if let userDs = UserDefaults(suiteName: "group.adynak.wineGPS") {
            userDs.set(value as AnyObject, forKey: "userPword")
        }
        set(value, forKey: UserDefaultsKeys.userPword.rawValue)
        synchronize()
    }
    
    func setWidgetVarietal(value: String) {
        set(value, forKey: UserDefaultsKeys.widgetVarietal.rawValue)
        synchronize()
    }
    
    func getUserName() -> String{
        return string(forKey: UserDefaultsKeys.userName.rawValue)!
    }
    
    func getUserPword() -> String{
        return string(forKey: UserDefaultsKeys.userPword.rawValue)!
    }
    
    func getShowBarcode() -> Bool{
        return bool(forKey: UserDefaultsKeys.showBarcode.rawValue)
    }
    
    func getShowPages() -> Bool{
        return bool(forKey: UserDefaultsKeys.showPages.rawValue)
    }
    
    func getRememberMe() -> Bool{
        return bool(forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
    
    func getiCloudStatus() -> Bool {
        return bool(forKey: UserDefaultsKeys.iCloudAvailable.rawValue)
    }
    
    func getWidgetVarietal() -> String{
        return string(forKey: UserDefaultsKeys.widgetVarietal.rawValue)!
    }

}
