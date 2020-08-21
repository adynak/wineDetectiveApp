//
//  SearchKeys.swift
//  wineApp
//
//  Created by adynak on 1/1/20.
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
    var description: String?
    
    static func BuildSearchKeys(wines: inout [AllLevel0]) -> [SearchKeys] {
        var searchWines = [SearchKeys]()
        var searchBins = [StorageBins]()
        var description: String = ""
        var designation: String = ""
        var vineyard: String = ""
        var producer: String = ""
        
        for wine in wines{
            designation = wine.label[0].designation
            vineyard = wine.label[0].vineyard
            producer = wine.label[0].producer
            
            if designation == "" && vineyard == "" {
                description = wine.label[0].producer
            }
            
            if designation == "" && vineyard != "" {
                description = producer + " " + vineyard
            }
            
            if designation != "" && vineyard == "" {
                description = producer + " " + designation
            }
            
            if designation != "" && vineyard != "" {
                description = designation + " " + vineyard
                description = description.replacingOccurrences(of: designation, with: "")
                description = producer + " " + description
            }
            
            description = description.condensedWhitespace

            let searchKey = wine.label[0].vintage + " " +
                            wine.label[0].varietal + " " +
                            producer + " " +
                            vineyard + " " +
                            wine.label[0].ava + " " +
                            designation + " " +
                            wine.label[0].country
            
            for storage in wine.storage{
                searchBins.append(StorageBins(binName: storage.bin,
                                              bottleCount: 1,
                                              binLocation: storage.location,
                                              barcode: storage.barcode,
                                              iwine: storage.iwine))
            }
                        
            searchWines.append(SearchKeys(vintage: wine.label[0].vintage,
                                       producer: producer,
                                       varietal: wine.label[0].varietal,
                                       appellation: wine.label[0].ava,
                                       region: wine.label[0].region,
                                       country: wine.label[0].country,
                                       locale: wine.label[0].locale,
                                       type: wine.label[0].type,
                                       designation: designation,
                                       vineyard: vineyard,
                                       drinkBy: wine.label[0].drinkBy,
                                       searckKey: searchKey,
                                       storageBins: searchBins,
                                       description: description)
            )
            searchBins.removeAll()
        }
        return searchWines
    }
    
}
