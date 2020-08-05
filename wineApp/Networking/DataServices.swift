//
//  DataServices.swift
//  wineApp
//
//  Created by adynak on 4/26/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

let debug: Bool = false

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
        var urlComponents = URLComponents()

        var url: URL
        if (debug == true){
//            url = URL.init(scheme: "http", host: "73.25.25.100", path: "/wine/resources/dataservices/csv.php")
//            urlComponents.port = 88
            url = URL.init(scheme: "http", host: "10.0.1.9", path: "/angular/git/wine/resources/dataservices/csv.php")

        } else {
            url = URL.init(scheme: "https", host: "www.cellartracker.com", path: "/xlquery.asp")
        }
        
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
        let fieldsWeCareAbout: [String] = ["Vintage","Varietal","iWine","Producer","Location","Bin","Vineyard","Designation","Appellation","Locale","Type","Region","Country","BeginConsume","EndConsume","Barcode","Available","Linear","Bell","Early","Late","Fast","TwinPeak","Simple", "wdVarietal"]

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
    
    static func buildAvailabilityVarietal( row: [String], positionOfVarietal: Int, positionOfType: Int) -> String{
        
        var varietal = row[positionOfVarietal]
        let type = row[positionOfType]
                
        if (type.localizedCaseInsensitiveContains("Ros")) {
            if(varietal.contains("Ros")) {

            } else {
                varietal = type + " of " + varietal
            }
        }

        return varietal
    }

    static func buildDrillIntoBottlesArray(fields:[Int], sortKeys: [String], missingOnly: Bool)->[DrillLevel0]{
        
        let positionOf = Label(data:fields)
        
        let mirror = Mirror(reflecting: positionOf)
        var sortIndex0: Int = 0
        var sortIndex1: Int = 0
        
        var level0: [DrillLevel0] = []
        var level1: [DrillLevel1] = []
        var level2: [DrillLevel2] = []
        
        var name: String = ""
        var iWine: String = ""

        var bottleCount: Int = 0
        
        for child in mirror.children  {
            if child.label == sortKeys[0]{
                sortIndex0 = child.value as! Int
            }
        }
        
        for child in mirror.children  {
            if child.label == sortKeys[1]{
                sortIndex1 = child.value as! Int
            }
        }

        var wines: [DrillBottle] = []
        
        for row in dataArray{
            let vintage = (row[positionOf.vintage] == "1001") ? "NV" : row[positionOf.vintage]

            let bottle = DrillBottle(
                producer: row[positionOf.producer],
                varietal: row[positionOf.wdVarietal],
                location: row[positionOf.location],
                bin: row[positionOf.bin],
                vintage: vintage,
                iWine: row[positionOf.iWine],
                barcode: row[positionOf.barcode],
                available: row[positionOf.available],
                linear: row[positionOf.linear],
                bell: row[positionOf.bell],
                early: row[positionOf.early],
                late: row[positionOf.late],
                fast: row[positionOf.fast],
                twinpeak: row[positionOf.twinpeak],
                simple: row[positionOf.simple],
                designation: row[positionOf.designation],
                ava: row[positionOf.ava],
                beginConsume: row[positionOf.beginConsume],
                endConsume: row[positionOf.endConsume],
                sortKey0: row[sortIndex0],
                sortKey1: row[sortIndex1]
            )
            
            if missingOnly {
                if row[positionOf.beginConsume] == "" && row[positionOf.endConsume] == ""{
                    wines.append(bottle)
                }
            } else {
                wines.append(bottle)
            }
        }

        let groupLevel0 = Dictionary(grouping: wines, by: { $0.sortKey0 })

        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.sortKey1 })
            for (item1) in groupLevel1{
                let groupLevel2 = Dictionary(grouping: item1.value, by: { $0.sortKey1 })
                for (item2) in groupLevel2{
                    for (detail) in item2.value {
                        bottleCount += 1
                        var sortKey = designation == "" ? detail.ava : "\(detail.designation) \(detail.ava)"
                        sortKey = "\(detail.vintage) \(sortKey)"
                        level2.append(DrillLevel2(producer: detail.producer,
                                             varietal: detail.varietal,
                                             vintage: detail.vintage,
                                             iWine: detail.iWine,
                                             location: detail.location,
                                             bin: detail.bin,
                                             barcode: detail.barcode,
                                             designation: detail.designation,
                                             ava: detail.ava,
                                             sortKey: sortKey,
                                             beginConsume: detail.beginConsume,
                                             endConsume: detail.endConsume))
                    }
                    
                    level2 =  level2.sorted(by: {
                        ($0.sortKey!.lowercased()) < ($1.sortKey!.lowercased())
                    })
                                        
                    if missingOnly {
                        for detail in level2 {
                            if iWine != detail.iWine {
                                if detail.designation == "" {
                                    name = "\(detail.vintage!) \(detail.varietal!)"
                                } else {
                                    name = "\(detail.vintage!) \(detail.designation!) \(detail.varietal!)"
                                    name = removeDuplicates(source: name.components(separatedBy: " ")).joined(separator:" ")
                                }
                                level1.append(DrillLevel1(name: name, bottleCount: level2.count, data: level2))
                                iWine = detail.iWine!
                            }
                        }
                    } else {
                        level1.append(DrillLevel1(name: item1.key, bottleCount: level2.count, data: level2))

                    }
                    level2.removeAll()
                }
            }
            
            level1 =  level1.sorted(by: {
                ($0.name!.lowercased()) < ($1.name!.lowercased())
            })
            level0.append(DrillLevel0(name: item0.key, bottleCount: bottleCount, data: level1))
            bottleCount = 0
            level1.removeAll()

        }

        level0 =  level0.sorted(by: {
            ($0.name!.lowercased()) < ($1.name!.lowercased())
        })

        return level0
    }
    
    static func buildDrillIntoBottlesArraySave(fields:[Int], sortKeys: [String], missingOnly: Bool)->[DrillLevel0]{
        
        let positionOf = Label(data:fields)
        
        let mirror = Mirror(reflecting: positionOf)
        var sortIndex0: Int = 0
        var sortIndex1: Int = 0
        
        var level0: [DrillLevel0] = []
        var level1: [DrillLevel1] = []
        var level2: [DrillLevel2] = []

        var bottleCount: Int = 0
        
        for child in mirror.children  {
            if child.label == sortKeys[0]{
                sortIndex0 = child.value as! Int
            }
        }
        
        for child in mirror.children  {
            if child.label == sortKeys[1]{
                sortIndex1 = child.value as! Int
            }
        }

        var wines: [DrillBottle] = []
        
        for row in dataArray{
            let vintage = (row[positionOf.vintage] == "1001") ? "NV" : row[positionOf.vintage]

            let bottle = DrillBottle(
                producer: row[positionOf.producer],
                varietal: row[positionOf.wdVarietal],
                location: row[positionOf.location],
                bin: row[positionOf.bin],
                vintage: vintage,
                iWine: row[positionOf.iWine],
                barcode: row[positionOf.barcode],
                available: row[positionOf.available],
                linear: row[positionOf.linear],
                bell: row[positionOf.bell],
                early: row[positionOf.early],
                late: row[positionOf.late],
                fast: row[positionOf.fast],
                twinpeak: row[positionOf.twinpeak],
                simple: row[positionOf.simple],
                designation: row[positionOf.designation],
                ava: row[positionOf.ava],
                beginConsume: row[positionOf.beginConsume],
                endConsume: row[positionOf.endConsume],
                sortKey0: row[sortIndex0],
                sortKey1: row[sortIndex1]
            )
            
            if missingOnly {
                if row[positionOf.beginConsume] == "" && row[positionOf.endConsume] == ""{
                    wines.append(bottle)
                }
            } else {
                wines.append(bottle)
            }
        }

        let groupLevel0 = Dictionary(grouping: wines, by: { $0.sortKey0 })

        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.sortKey1 })
            for (item1) in groupLevel1{
                let groupLevel2 = Dictionary(grouping: item1.value, by: { $0.sortKey1 })
                for (item2) in groupLevel2{
                    for (detail) in item2.value {
                        bottleCount += 1
                        var sortKey = designation == "" ? detail.ava : "\(detail.designation) \(detail.ava)"
                        sortKey = "\(detail.vintage) \(sortKey)"
                        level2.append(DrillLevel2(producer: detail.producer,
                                             varietal: detail.varietal,
                                             vintage: detail.vintage,
                                             iWine: detail.iWine,
                                             location: detail.location,
                                             bin: detail.bin,
                                             barcode: detail.barcode,
                                             designation: detail.designation,
                                             ava: detail.ava,
                                             sortKey: sortKey,
                                             beginConsume: detail.beginConsume,
                                             endConsume: detail.endConsume))
                    }
                    
                    level2 =  level2.sorted(by: {
                        ($0.sortKey!.lowercased()) < ($1.sortKey!.lowercased())
                    })

                    level1.append(DrillLevel1(name: item1.key, bottleCount: level2.count, data: level2))
                    level2.removeAll()
                }
            }
            
            level1 =  level1.sorted(by: {
                ($0.name!.lowercased()) < ($1.name!.lowercased())
            })
            level0.append(DrillLevel0(name: item0.key, bottleCount: bottleCount, data: level1))
            bottleCount = 0
            level1.removeAll()

        }

        level0 =  level0.sorted(by: {
            ($0.name!.lowercased()) < ($1.name!.lowercased())
        })

        return level0
    }
    
    static func buildAllBottlesArray(fields:[Int])->[AllLevel0]{
        
        var level0: [AllLevel0] = []
        var level1: [AllLevel1] = []
        var wines: [Bottle] = []
        var label: [bottleDetail] = []
        let positionOf = Label(data:fields)
        
        for row in dataArray{
            let bottleSort = row[positionOf.wdVarietal] + " " + row[positionOf.vintage] + " " + row[positionOf.producer]
            let binSort = row[positionOf.location] + row[positionOf.bin]
            let bottle = Bottle(producer: row[positionOf.producer], varietal: row[positionOf.wdVarietal], location: row[positionOf.location], bin: row[positionOf.bin], vintage: row[positionOf.vintage], iWine: row[positionOf.iWine], barcode: row[positionOf.barcode], available: row[positionOf.available], linear: row[positionOf.linear], bell: row[positionOf.bell], early: row[positionOf.early], late: row[positionOf.late], fast: row[positionOf.fast], twinpeak: row[positionOf.twinpeak], simple: row[positionOf.simple], beginConsume: row[positionOf.beginConsume], endConsume: row[positionOf.endConsume], sortKey: "", ava: row[positionOf.ava], designation: row[positionOf.designation], bottleSort: bottleSort, binSort: binSort, region: row[positionOf.region], country: row[positionOf.country], vineyard: row[positionOf.vineyard], locale: row[positionOf.locale], type: row[positionOf.type])
            wines.append(bottle)
        }
        
        let groupLevel0 = Dictionary(grouping: wines, by: { $0.bottleSort })
        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.binSort })
            for (item1) in groupLevel1{
                for (detail) in item1.value {
                    level1.append(AllLevel1(
                        location: detail.location,
                        bin: detail.bin,
                        barcode: detail.barcode,
                        binSort: detail.binSort,
                        iwine: detail.iWine))
                }
                level1 =  level1.sorted(by: {
                    ($0.binSort.lowercased()) < ($1.binSort.lowercased())
                })
            }
            for (item) in item0.value {
                let vintage = (item.vintage == "1001") ? "NV" : item.vintage

                label.append(bottleDetail(vvp: item.varietal + " " +
                                               vintage + " " +
                                               item.producer,
                                          vintage: vintage,
                                          varietal: item.varietal,
                                          producer: item.producer,
                                          vineyard: item.vineyard,
                                          ava: item.ava,
                                          designation: item.designation,
                                          region: item.ava,
                                          country: item.country,
                                          locale: item.locale,
                                          type: item.type,
                                          drinkBy: buildDrinkBy(beginConsume: item.beginConsume, endConsume: item.endConsume),
                                          available: item.available.floatValue,
                                          linear: item.linear.floatValue,
                                          bell: item.bell.floatValue,
                                          early: item.early.floatValue,
                                          late: item.late.floatValue,
                                          fast: item.fast.floatValue,
                                          twinPeak: item.twinpeak.floatValue,
                                          simple: item.simple.floatValue,
                                          bottleCount: level1.count))
                break
            }
            level0.append(AllLevel0(label: label, storage: level1))
            level1.removeAll()
            label.removeAll()
        }

        return level0
    }

    
    static func buildLocationArray(fields:[Int])->[Level0]{
        
        var wines: [Bottle] = []
        let positionOf = Label(data:fields)

        for row in dataArray{
                        
            let bottle = Bottle(
                producer: row[positionOf.producer],
                varietal: row[positionOf.varietal],
                location: row[positionOf.location],
                bin: row[positionOf.bin],
                vintage: row[positionOf.vintage],
                iWine: row[positionOf.iWine],
                barcode: row[positionOf.barcode],
                available: row[positionOf.available],
                linear: row[positionOf.linear],
                bell: row[positionOf.bell],
                early: row[positionOf.early],
                late: row[positionOf.late],
                fast: row[positionOf.fast],
                twinpeak: row[positionOf.twinpeak],
                simple: row[positionOf.simple],
                beginConsume: row[positionOf.beginConsume],
                endConsume: row[positionOf.endConsume],
                sortKey: row[positionOf.available],
                ava: row[positionOf.designation],
                designation: row[positionOf.designation],
                bottleSort: "",
                binSort: "",
                region: "",
                country: "",
                vineyard: "",
                locale: "",
                type: ""
            )

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
                                             location: detail.location,
                                             bin: detail.bin,
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
        
    static func removeBottles(bottles: [DrillLevel2]){
        let fields = DataServices.locateDataPositions(dataHeader:dataHeader)
        var dataArrayFiltered = [[String]]()
        
        for bottle in bottles{            
            let barcode = bottle.barcode!.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            let iwine = bottle.iWine!.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            print(barcode + " " + iwine)
            
            dataArrayFiltered = dataArray.filter { !$0[1].contains(barcode) }
            dataArray = dataArrayFiltered
        }
                
        let locationSort = DataServices.buildDrillIntoBottlesArray(
                                fields: fields,
                                sortKeys: ["location","bin"],
                                missingOnly: false)

        let searchSort = DataServices.buildAllBottlesArray(fields: fields)
                                                        
        let producerSort = DataServices.buildDrillIntoBottlesArray(
                                fields: fields,
                                sortKeys: ["producer","wdVarietal"],
                                missingOnly: false)

        let varietalSort = DataServices.buildDrillIntoBottlesArray(
                                fields: fields,
                                sortKeys: ["wdVarietal","producer"],
                                missingOnly: false)
        let missingSort = DataServices.buildDrillIntoBottlesArray(
                                fields: fields,
                                sortKeys: ["producer","iWine"],
                                missingOnly: true)
                                                
        let newInventory = WineInventory(producers: producerSort,
                                         varietals: varietalSort,
                                         search: searchSort,
                                         location: locationSort,
                                         missing: missingSort)
        
        print("rebuild data arrays complete")
        allWine = newInventory
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBottles"), object: nil)

    }

    static func locateAvailabilityFields(availabilityHeader: [String?]) -> [Int]{
        
        var fields = [Int]()
        let fieldsWeCareAbout: [String] = ["iWine","Available","Linear","Bell","Early","Late","Fast","TwinPeak","Simple", "wdVarietal"]

        for field in fieldsWeCareAbout{
            if let i = availabilityHeader.firstIndex(where: { $0 == field }) {
                fields.append(i)
            }
        }
        return fields
    }
    
    static func removeDuplicates<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

    
}

