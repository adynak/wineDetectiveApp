//
//  SettingsSection.swift
//  SettingsTemplate
//
//  Created by adynak on 7/1/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

protocol SectionType : CustomStringConvertible {
    var containsSwitch: Bool {get}
    var switchNumber: Int {get}
}

enum MoreMenuSections: Int, CaseIterable, CustomStringConvertible{
    case Reports
    case Settings
    
    var description: String{
        switch self{
        case .Reports:
            return NSLocalizedString("menuReports", comment: "").uppercased()
        case .Settings:
            return NSLocalizedString("menuSettings", comment: "").uppercased()
        }
    }
    
    var sectionRowCount: Int{
        switch self{
        case .Reports:
            return ReportNames.allCases.count
        case .Settings:
            return AppOptions.allCases.count
        }
    }
}

enum ReportNames: Int, CaseIterable, SectionType{
    case producer
    case varietal
    case location
    case missingDates
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self{
        case .producer:
            return NSLocalizedString("reportProducer", comment: "")
        case .varietal:
            return NSLocalizedString("reportVarietal", comment: "")
        case .location:
            return NSLocalizedString("reportLocation", comment: "")
        case .missingDates:
            return NSLocalizedString("reportMissingDates", comment: "")
        }
    }
    
    var thumbnail: String{
        switch self{
        case .producer:
            return "producer.png"
        case .varietal:
            return "varietal.png"
        case .location:
            return "location.png"
        case .missingDates:
            return "calendar.png"
        }
    }
    
    var controller: String{
        switch self{
        case .producer:
            return "producer"
        case .varietal:
            return "varietal"
        case .location:
            return "location"
        case .missingDates:
            return "missingDates"

        }
    }
    
    var switchNumber: Int{
        switch self{
        case .producer:
            return 0
        case .varietal:
            return 1
        case .location:
            return 2
        case .missingDates:
            return 0
        }
    }
}

enum AppOptions: Int, CaseIterable, SectionType{
    case showBarcode
    case showMeHow
    case support
    
    var containsSwitch: Bool {
        switch self{
            case .showBarcode:
                return true
            case .showMeHow:
                return true
            case .support:
                return false
        }
    }
    
    var description: String{
        switch self{
        case .showBarcode:
            return NSLocalizedString("settingBarcode", comment: "")
        case .showMeHow:
            return NSLocalizedString("settingShowMe", comment: "")
        case .support:
            return NSLocalizedString("settingSupport", comment: "")
        }
    }
    
    var thumbnail: String{
        switch self{
        case .showBarcode:
            return "barcode.png"
        case .showMeHow:
            return "pages.png"
        case .support:
            return "support.png"
        }
    }
    
    var controller: String{
        switch self{
        case .showBarcode:
            return ""
        case .showMeHow:
            return ""
        case .support:
            return "support"
        }
    }
    
    var switchNumber: Int{
        switch self{
        case .showBarcode:
            return 3
        case .showMeHow:
            return 4
        case .support:
            return 5
        }
    }

    
}
