//
//  VarietalProvider.swift
//  WineGPS
//
//  Created by adynak on 9/24/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

public struct VarietalProvider {
    
    static func all() -> [VarietalDetails] {
        
        let bottles = API.load()

        varietals.removeAll()
        
        for bottle in bottles {
            let thisBottle = VarietalDetails(name: bottle.key, description: "desc", varietalCount: bottle.value)
            varietals.append(thisBottle)
        }

        varietals =  varietals.sorted(by: {
            ($0.name.lowercased()) < ($1.name.lowercased())
        })
        
        if let i = varietals.firstIndex(where: { $0.name == "TotalBottles" }) {
            let element = varietals.remove(at: i)
            varietals.insert(element, at: 0)
        }

        return varietals
    }

    static func random() -> VarietalDetails {
        let allVarietals = VarietalProvider.all()
        let randomIndex = Int.random(in: 0..<allVarietals.count)
        return allVarietals[randomIndex]
    }
}
