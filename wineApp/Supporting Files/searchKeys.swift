//
//  temp.swift
//  wineApp
//
//  Created by adynak on 5/12/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

struct SearchKeys {
    let vintage: String
    let producer: String
    let varietal: String
    let appellation: String
    let region: String
    let country: String
    let locale: String
    let type: String
    let designation: String
    let vineyard: String
    let drinkBy: String
    let searckKey: String
    var storageBins: [StorageBins]?
    
    static func BuildSearchKeys0(wines: inout [AllLevel0]) -> [SearchKeys] {
        var searchWines = [SearchKeys]()
        
        for wine in wines{
            print(wine.label[0].vintage)
        }
        
        wines.forEach {
            for wine in $0.label{
//                let searchKey = wine.vintage + " " +
//                                wine.varietal + " " +
//                                wine.producer + " " +
//                                wine.vineyard + " " +
//                                wine.ava + " " +
//                                wine.designation
//
//                searchWines.append(SearchKeys(vintage: wine.vintage,
//                                           producer: wine.producer,
//                                           varietal: wine.varietal,
//                                           appellation: wine.ava,
//                                           region: wine.region,
//                                           country: wine.country,
//                                           locale: wine.locale,
//                                           type: wine.type,
//                                           designation: wine.designation,
//                                           vineyard: wine.vineyard,
//                                           drinkBy: wine.drinkBy,
//                                           searckKey: searchKey)
////                                           storageBins: wine.storageBins)
//                )

            }

        }
        return searchWines

    }
    
    static func BuildSearchKeys(varietals: inout [Producers]) -> [SearchKeys] {
        
        var searchWines = [SearchKeys]()
        
        varietals.forEach {
            for (wine) in $0.wines!{
                let searchKey = wine.vintage! + " " +
                                wine.varietal! + " " +
                                wine.producer! + " " +
                                wine.vineyard! + " " +
                                wine.ava! + " " +
                                wine.designation!
                    
                searchWines.append(SearchKeys(vintage: wine.vintage!,
                                           producer: wine.producer!,
                                           varietal: wine.varietal!,
                                           appellation: wine.ava!,
                                           region: wine.region!,
                                           country: wine.country!,
                                           locale: wine.locale!,
                                           type: wine.type!,
                                           designation: wine.designation!,
                                           vineyard: wine.vineyard!,
                                           drinkBy: wine.drinkBy!,
                                           searckKey: searchKey,
                                           storageBins: wine.storageBins)
                )
            }
            
        }

        return searchWines
    }
}
