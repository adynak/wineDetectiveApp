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
        return [
            VarietalDetails(
                name: "Barbera",
                description: "red",
                varietalCount: 19),
            VarietalDetails(
                name: "Bastardo",
                description: "red",
                varietalCount: 29),
            VarietalDetails(
                name: "Cabernet Franc",
                description: "red",
                varietalCount: 39),
            VarietalDetails(
                name: "Cabernet Sauvignon",
                description: "red",
                varietalCount: 49),
            VarietalDetails(
                name: "Carménère",
                description: "red",
                varietalCount: 59),
            VarietalDetails(
                name: "Chardonnay",
                description: "red",
                varietalCount: 69),
            VarietalDetails(
                name: "Dolcetto",
                description: "red",
                varietalCount: 79),
            VarietalDetails(
                name: "Gewürztraminer ",
                description: "red",
                varietalCount: 89),
            VarietalDetails(
                name: "Graciano",
                description: "red",
                varietalCount: 99),
            VarietalDetails(
                name: "Grenache ",
                description: "red",
                varietalCount: 11),
            VarietalDetails(
                name: "Lemberger",
                description: "red",
                varietalCount: 21),
            VarietalDetails(
                name: "Malbec ",
                description: "red",
                varietalCount: 31)
        ]
    }

    static func random() -> VarietalDetails {
        let allVarietals = VarietalProvider.all()
        let randomIndex = Int.random(in: 0..<allVarietals.count)
        return allVarietals[randomIndex]
    }
}
