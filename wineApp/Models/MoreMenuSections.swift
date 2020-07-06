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
    case reconcile
    
    var containsSwitch: Bool {
        return false
    }
    
    var description: String{
        switch self{
        case .producer:
            return NSLocalizedString("reportProducer", comment: "")
        case .varietal:
            return NSLocalizedString("reportVarietal", comment: "")
        case .reconcile:
            return NSLocalizedString("reportReconcile", comment: "")
        }
    }
    
    var controller: String{
        switch self{
        case .producer:
            return "producer"
        case .varietal:
            return "varietal"
        case .reconcile:
            return "reconcile"
        }
    }
}

enum AppOptions: Int, CaseIterable, SectionType{
    case showBarcode
    case help
    
    var containsSwitch: Bool {
        switch self{
            case .showBarcode:
                return true
            case .help:
                return false
        }
    }
    
    var description: String{
        switch self{
        case .showBarcode:
            return NSLocalizedString("settingBarcode", comment: "")
        case .help:
            return NSLocalizedString("settingSupport", comment: "")
        }
    }
}
