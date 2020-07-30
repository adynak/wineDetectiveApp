//
//  SettingsSection.swift
//  SettingsTemplate
//
//  Created by adynak on 7/1/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

enum SupportMenuSections: Int, CaseIterable, CustomStringConvertible{
    case Contact
    case Version
    
    var description: String{
        switch self{
        case .Contact:
            return NSLocalizedString("menuContacts", comment: "contacts menu item").uppercased()
        case .Version:
            return NSLocalizedString("menuVersion", comment: "version menu item").uppercased()
        }
    }
    
    var sectionRowCount: Int{
        switch self{
        case .Contact:
            return ContactNames.allCases.count
        case .Version:
            return VersionOptions.allCases.count
        }
    }
}

enum ContactNames: Int, CaseIterable , SectionType {
    
    case support
    
    var containsSwitch: Bool {
        return false
    }
        
    var description: String{
        switch self{
        case .support:
            return NSLocalizedString("emailContactMenu", comment: "email menu item")
        }
    }
    
    var thumbnail: String{
        switch self{
        case .support:
            return "mail.png"
        }
    }
    
    var controller: String{
        switch self{
        case .support:
            return "sendEmail"
        }
    }
    
    var switchNumber: Int{
        switch self{
        case .support:
            return 0
        }
    }


    
}

enum VersionOptions: Int, CaseIterable, SectionType{
    case version
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self{
        case .version:
            return Bundle.main.versionAndBuildPretty
        }
    }
    
    var thumbnail: String{
        switch self{
        case .version:
            return "bottleLogo.png"
        }
    }
    
    var switchNumber: Int{
        switch self{
        case .version:
            return 0
        }
    }
        
}
