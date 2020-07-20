//
//  UserDefaults+helpers.swift
//  audible
//
//  Created by Brian Voong on 10/3/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case userName
        case userPword
        case showBarcode
        case showPages
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
        set(value, forKey: UserDefaultsKeys.userName.rawValue)
        synchronize()
    }
    
    func setUserPword(value: String) {
        set(value, forKey: UserDefaultsKeys.userPword.rawValue)
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
}
