//
//  API.swift
//  wineApp
//
//  Created by adynak on 6/10/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case server
}

var availabilityArray = [[String]]()
var inventoryArray = [[String]]()
var availabilityHeader = [String?]()

struct Availability{
    let iWine: Int
    let available: Int
    let linear: Int
    let bell: Int
    let early: Int
    let fast: Int
    let twinPeak: Int
    let simple: Int
    
    init(data: [Int]) {
        iWine = data[0]
        available = data[1]
        linear = data[2]
        bell = data[3]
        early = data[4]
        fast = data[5]
        twinPeak = data[6]
        simple = data[7]
    }
}
