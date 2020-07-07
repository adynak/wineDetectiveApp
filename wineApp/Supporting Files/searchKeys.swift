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
    
    static func BuildSearchKeys(wines: inout [AllLevel0]) -> [SearchKeys] {
        var searchWines = [SearchKeys]()
        var searchBins = [StorageBins]()
        
        for wine in wines{
            let searchKey = wine.label[0].vintage + " " +
                            wine.label[0].varietal + " " +
                            wine.label[0].producer + " " +
                            wine.label[0].vineyard + " " +
                            wine.label[0].ava + " " +
                            wine.label[0].designation
            
            for storage in wine.storage{
                searchBins.append(StorageBins(binName: storage.bin, bottleCount: 1, binLocation: storage.location, barcode: storage.barcode))
            }
                        
            searchWines.append(SearchKeys(vintage: wine.label[0].vintage,
                                       producer: wine.label[0].producer,
                                       varietal: wine.label[0].varietal,
                                       appellation: wine.label[0].ava,
                                       region: wine.label[0].region,
                                       country: wine.label[0].country,
                                       locale: wine.label[0].locale,
                                       type: wine.label[0].type,
                                       designation: wine.label[0].designation,
                                       vineyard: wine.label[0].vineyard,
                                       drinkBy: wine.label[0].drinkBy,
                                       searckKey: searchKey,
                                       storageBins: searchBins)
            )
            searchBins.removeAll()
        }
        return searchWines
    }
    
}
