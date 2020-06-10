//
//  DataServices.swift
//  wineApp
//
//  Created by adynak on 4/26/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

let debug: Bool = true

class DataServices {
        
    static func parseCsv(data: String) -> [[String]]{
        // data: String = contents of a CSV file.
        // Returns: [[String]] = two-dimension array [rows][columns].
        // Data minimum two characters or fail.
        if data.count < 2 {
            return []
        }
        var a: [String] = [] // Array of columns.
        var index: String.Index = data.startIndex
        let maxIndex: String.Index = data.index(before: data.endIndex)
        var q: Bool = false // "Are we in quotes?"
        var result: [[String]] = []
        var v: String = "" // Column value.
        while index < data.endIndex {
            if q { // In quotes.
                if (data[index] == "\"") {
                    // Found quote; look ahead for another.
                    if index < maxIndex && data[data.index(after: index)] == "\"" {
                        // Found another quote means escaped.
                        // Increment and add to column value.
                        data.formIndex(after: &index)
                        v += String(data[index])
                    } else {
                        // Next character not a quote; last quote not escaped.
                        q = !q // Toggle "Are we in quotes?"
                    }
                } else {
                    // Add character to column value.
                    v += String(data[index])
                }
            } else { // Not in quotes.
                if data[index] == "\"" {
                    // Found quote.
                    q = !q // Toggle "Are we in quotes?"
                } else if data[index] == "\n" || data[index] == "\r\n" {
                    // Reached end of line.
                    // Column and row complete.
                    a.append(v)
                    v = ""
                    result.append(a)
                    a = []
                } else if data[index] == "," {
                    // Found comma; column complete.
                    a.append(v)
                    v = ""
                } else {
                    // Add character to column value.
                    v += String(data[index])
                }
            }
            if index == maxIndex {
                // Reached end of data; flush.
                if v.count > 0 || data[data.index(before: index)] == "," {
                    a.append(v)
                }
                if a.count > 0 {
                    result.append(a)
                }
                break
            }
            data.formIndex(after: &index) // Increment.
        }
        return result
    }
    
    static func getDataUrl(user: String,pword: String, table: String) -> String{
        
        struct URL {
            let scheme: String
            let host: String
            let path: String
            
        }
        var url: URL
        if (debug == true){
            url = URL.init(scheme: "http", host: "10.0.1.9", path: "/angular/git/wine/resources/dataservices/csv.php")
        } else {
            url = URL.init(scheme: "https", host: "www.cellartracker.com", path: "/xlquery.asp")
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = url.scheme
        urlComponents.host = url.host
        urlComponents.path = url.path
        urlComponents.queryItems = [
           URLQueryItem(name: "User", value: user),
           URLQueryItem(name: "Password", value: pword),
           URLQueryItem(name: "Format", value: "csv"),
           URLQueryItem(name: "Table", value: table),
           URLQueryItem(name: "Location", value: "1")
        ]

        let dataUrl = urlComponents.url!.absoluteString
        return dataUrl
    }
    
    static func locateDataPositions(dataHeader: [String]) -> [Int]{
        
        var fields = [Int]()
        let fieldsWeCareAbout: [String] = ["Vintage","Varietal","iWine","Producer","Location","Bin","Vineyard","Designation","Appellation","Locale","Type","Region","Country","BeginConsume","EndConsume","Barcode"]

        for field in fieldsWeCareAbout{
            if let i = dataHeader.firstIndex(where: { $0 == field }) {
                fields.append(i)
            }
        }
        return fields
    }
    
    static func buildVarietal( row: [String], positionOf: Label) -> String{
        
        var varietal = row[positionOf.varietal]
        let type = row[positionOf.type]
                
        if (type.localizedCaseInsensitiveContains("Ros")) {
            if(varietal.contains("Ros")) {

            } else {
                varietal = type + " of " + varietal
            }
        }

        return varietal
    }
    
    static func buildReconcileArray(fields:[Int])->[Level0]{
        
        var wines: [Bottle] = []
        let positionOf = Label(data:fields)

        for row in dataArray{
            
            let bottle = Bottle(producer: row[positionOf.producer], varietal: row[positionOf.varietal], location: row[positionOf.location], bin: row[positionOf.bin], vintage: row[positionOf.vintage], iWine: row[positionOf.iWine], barcode: row[positionOf.barcode])

            wines.append(bottle)
        }
                
        var level0: [Level0] = []
        var level1: [Level1] = []
        var level2: [Level2] = []
        var bottleCount: Int = 0

        let groupLevel0 = Dictionary(grouping: wines, by: { $0.location })

        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.bin })
            for (item1) in groupLevel1{
                let groupLevel2 = Dictionary(grouping: item1.value, by: { $0.bin })
                for (item2) in groupLevel2{
                    for (detail) in item2.value {
                        bottleCount += 1
                        level2.append(Level2(producer: detail.producer,
                                             varietal: detail.varietal,
                                             vintage: detail.vintage,
                                             iWine: detail.iWine,
                                             barcode: detail.barcode))
                    }
                    
                    level2 =  level2.sorted(by: {
                        ($0.producer!.lowercased()) < ($1.producer!.lowercased())
                    })

                    level1.append(Level1(name: item1.key, bottleCount: level2.count, data: level2))
                    level2.removeAll()
                }
            }
            
            level1 =  level1.sorted(by: {
                ($0.name!.lowercased()) < ($1.name!.lowercased())
            })
            level0.append(Level0(name: item0.key, bottleCount: bottleCount, data: level1))
            bottleCount = 0
            level1.removeAll()

        }

        level0 =  level0.sorted(by: {
            ($0.name!.lowercased()) < ($1.name!.lowercased())
        })

        return level0
    }
        
    static func buildProducersArray(fields: [Int],
                                    sortKey: String) -> [Producers]{
        
        let positionOf = Label(data:fields)
        var locationBin: String
        var checkLocation: [StorageBins]
        var producer = [Producers]()
        var firstSortBy: Int
        var sortName: String
        
        switch sortKey {
            case "producer":
                firstSortBy = positionOf.producer
            case "varietal":
                firstSortBy = positionOf.varietal
            case "drinkBy":
                firstSortBy = positionOf.endConsume
            case "reconcile":
                firstSortBy = positionOf.location
            default:
                firstSortBy = positionOf.producer
        }
        
//        var x = (sortKey == "reconcile") ? row[positionOf.bin] : row[firstSortBy]
        
        for row in dataArray{
            // special transformations
            locationBin = row[positionOf.location] + row[positionOf.bin]
            let varietal = buildVarietal(row: row, positionOf: positionOf)
            let vintage = (row[positionOf.vintage] == "1001") ? "NV" : row[positionOf.vintage]
                        
            if sortKey == "varietal"{
                sortName = varietal
            } else {
                sortName = row[firstSortBy]
            }
            
            if let producerIndex = producer.firstIndex(where: { $0.name == sortName }) {
                if let iWineIndex = producer[producerIndex].wines!.firstIndex(where: { $0.iWine == row[positionOf.iWine] }) {
                    checkLocation = producer[producerIndex].wines![iWineIndex].storageBins!
                    // existing iWine, is it in the same bin as the existing bottle?
                    if let storageIndex = checkLocation.firstIndex(where: { ($0.binLocation! + $0.binName!) == locationBin }) {
                            // bottle is in the same bin, bump the bottle count
                        producer[producerIndex].wines![iWineIndex].storageBins![storageIndex].bottleCount! += 1
                        } else {
                            // bottle is in a new bin, add a new storage struct
                            bin.removeAll()
                            addNewStorage(binName: row[positionOf.bin], binLocation: row[positionOf.location], bin: &bin)
                            producer[producerIndex].wines![iWineIndex].storageBins!.append(contentsOf: bin)
                        }
                    producer[producerIndex].bottleCount! += 1
                } else {
                    // new wine for existing producer
                    wine.removeAll()
                    wine.append(Wines(iWine: row[positionOf.iWine],
                                      varietal: varietal,
                                      vineyard: row[positionOf.vineyard],
                                      vintage: vintage,
                                      designation: row[positionOf.designation],
                                      ava: row[positionOf.ava],
                                      region: row[positionOf.region],
                                      country: row[positionOf.country],
                                      locale: row[positionOf.locale],
                                      type: row[positionOf.type],
                                      drinkBy: buildDrinkBy(beginConsume: row[positionOf.beginConsume], endConsume: row[positionOf.endConsume]),
                                      producer: row[positionOf.producer],
                                      storageBins: bin))
                    // keep wines sorted by using insert
                    producer[producerIndex].bottleCount! += 1
                    let searchKey = row[positionOf.varietal] + row[positionOf.vintage]
                    if let index = producer[producerIndex].wines!.firstIndex(where: { $0.varietal! + $0.vintage! > searchKey}) {
                        producer[producerIndex].wines!.insert(contentsOf: wine, at: index)
                    } else {
                        producer[producerIndex].wines!.append(contentsOf:wine)
                    }

                }

            } else {
                // new producer
                wine.removeAll()
                bin.removeAll()
                addNewStorage(binName: row[positionOf.bin], binLocation: row[positionOf.location], bin: &bin)
                wine.append(Wines(iWine: row[positionOf.iWine],
                                  varietal: varietal,
                                  vineyard: row[positionOf.vineyard],
                                  vintage: vintage,
                                  designation: row[positionOf.designation],
                                  ava: row[positionOf.ava],
                                  region: row[positionOf.region],
                                  country: row[positionOf.country],
                                  locale: row[positionOf.locale],
                                  type: row[positionOf.type],
                                  drinkBy: buildDrinkBy(beginConsume: row[positionOf.beginConsume],endConsume: row[positionOf.endConsume]),
                                  producer: row[positionOf.producer],
                                  storageBins: bin))
                if sortKey == "varietal"{
                    sortName = varietal
                } else {
                    sortName = row[firstSortBy]
                }
                producer.append(Producers(name: sortName,
                                          isExpanded: false,
                                          bottleCount: 1,
                                          wines: wine))
            }

        }
        
        producer = producer.sorted {
            var isSorted = false
            if let first = $0.name, let second = $1.name {
                isSorted = first < second
            }
            return isSorted
        }
        
        return producer

    }
    
    static func removeBottles(bottles: [Level2]){
        let fields = DataServices.locateDataPositions(dataHeader:dataHeader)
        var dataArrayFiltered = [[String]]()
        
        for bottle in bottles{
            let barcode = bottle.barcode
            dataArrayFiltered = dataArray.filter { !$0[1].contains(barcode!) }
            dataArray = dataArrayFiltered
        }
                
        let reconcileSort = DataServices.buildReconcileArray(fields: fields)
        
        allWine?.reconcile = reconcileSort
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserlistUpdate"), object: nil)

    }
    
    static func locateAvailabilityFields(availabilityHeader: [String?]) -> [Int]{
        
        var fields = [Int]()
        let fieldsWeCareAbout: [String] = ["iWine","Available","Linear","Bell","Early","Late","Fast","TwinPeak","Simple"]

        for field in fieldsWeCareAbout{
            if let i = availabilityHeader.firstIndex(where: { $0 == field }) {
                fields.append(i)
            }
        }
        return fields
    }
    
}

