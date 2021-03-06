//
//  MoreMenuSections.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
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
            return NSLocalizedString("menuReports", comment: "menu item: Reports").uppercased()
        case .Settings:
            return NSLocalizedString("menuSettings", comment: "menu item: Settings").uppercased()
        }
    }
    
    var sectionRowCount: Int{
        switch self{
        case .Reports:
            // lucky for you the last report is the one we want to hide
            if allWine?.missing?.count == 0 {
                return ReportNames.allCases.count - 1
            } else {
                return ReportNames.allCases.count
            }
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
            return NSLocalizedString("reportProducer", comment: "menu item: Sort By Producer Report")
        case .varietal:
            return NSLocalizedString("reportVarietal", comment: "menu item: Sort By Varietal Report")
        case .location:
            return NSLocalizedString("reportLocation", comment: "menu item: Sort by Location Report")
        case .missingDates:
            return NSLocalizedString("reportMissingDates", comment: "menu item: Consume Dates Missing Report")
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
            return NSLocalizedString("settingBarcode", comment: "menu item: Show Barcode")
        case .showMeHow:
            return NSLocalizedString("settingShowMe", comment: "menu item: Show Walkthrough Pages")
        case .support:
            return NSLocalizedString("settingSupport", comment: "menu item: Support")
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
