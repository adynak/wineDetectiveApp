//
//  temp.swift
//  wineApp
//
//  Created by adynak on 5/12/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

struct sb {
    let binName: String
    let bottleCount: Int
    let binLocation: String

}


struct Country {
    let vintage: String
    let producer: String
    let varietal: String
    let appellation: String
    let drinkBy: String
    let searckKey: String
    let storageBins: sb
//
//    var binName: String?
//       var bottleCount: Int?
//       var binLocation: String?

    
    static func GetAllCountries() -> [Country] {
        return [
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Abacela", varietal: "Dolcetto", appellation: "Umpqua Valley", drinkBy: "2020-2022", searckKey: "2020 Abacela Dolcetto Umpqua Valley", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall")),
            Country(vintage: "2020", producer: "Zerba", varietal: "Syrah", appellation: "Walla Walla", drinkBy: "2020-2022", searckKey: "2020 Zerba Syrah Walla Walla", storageBins: sb(binName: "A", bottleCount: 1,binLocation: "Tall"))
        ]
    }
}
