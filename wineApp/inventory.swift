//
//  ExpandableNames.swift
//  wineApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import Foundation

struct InventoryByVintage {
    
    var isExpanded: Bool
    var vintage: String
    var producers: [String]
    var varietals: [String]
    var avas: [String]
    var designations: [String]
    var bottleCount: [String]
}

struct InventoryByVarietal {
    
    var isExpanded: Bool
    var varietal: String
    var producers: [String]
    var vintages: [String]
    var avas: [String]
    var designations: [String]
    var bottleCount: [String]
}

struct InventoryByProducer {
    
    var isExpanded: Bool
    var producer: String
    var vintages: [String]
    var varietals: [String]
    var avas: [String]
    var designations: [String]
    var bottleCount: [String]
}

struct wineDetail {
    var varietal = "123"
    var vintage = "123"
    var producer = "123"
    var ava = "123"
    var designation = "123"
    var bottleCount = "19"
}
