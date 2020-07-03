//
//  SettingsSection.swift
//  SettingsTemplate
//
//  Created by adynak on 7/1/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

protocol SectionType : CustomStringConvertible {
    var containsSwitch: Bool {get}
}

enum MoreMenuSections: Int, CaseIterable, CustomStringConvertible{
    case Reports
    case Settings
    
    var description: String{
        switch self{
        case .Reports:
            return "Reports"
        case .Settings:
            return "Settings"
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
            return "Sort By Producer"
        case .varietal:
            return "Sort By Varietal"
        case .reconcile:
            return "Reconcile Inventory"
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
            return "Show Bottle Barcode"
        case .help:
            return "Help"
        }
    }
}
