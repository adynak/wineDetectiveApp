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

//struct wineDetail {
//    var varietal = "123"
//    var vintage = "123"
//    var producer = "123"
//    var ava = "123"
//    var designation = "123"
//    var bottleCount = "19"
//}

struct wineDetail {
    var varietal = "123"
    var vintage = "123"
    var producer = "123"
    var vineyard = "123"
    var ava = "123"
    var designation = "123"
    var bottleCount = "19"
    var drinkBy = "123"
    var locale = "123"
    var region = "123"
    var country = "123"
    var type = "123"
    var storageBins: [StorageBins]?
}

struct WineInventory: Codable {
    var producers: [Producers]?
}

struct Producers: Codable {
    let name: String?
    var isExpanded: Bool?
    var wines : [Wines]?
}

struct Wines : Codable {
    let iWine: String?
    let varietal: String?
    let vineyard: String?
    let vintage: String?
    let designation: String?
    let ava: String?
    let region: String?
    let country: String?
    let locale: String?
    let type: String?
    let drinkBy: String?
    var storageBins: [StorageBins]?
}

struct Label{
    let vintage: Int
    let varietal: Int
    let iWine: Int
    let producer: Int
    let location: Int
    let bin: Int
    let vineyard: Int
    let designation: Int
    let ava: Int
    let locale: Int
    let type: Int
    let region: Int
    let country: Int
    let beginConsume: Int
    let endConsume: Int
    
    init(data: [Int]) {
        vintage = data[0]
        varietal = data[1]
        iWine = data[2]
        producer = data[3]
        location = data[4]
        bin = data[5]
        vineyard = data[6]
        designation = data[7]
        ava = data[8]
        locale = data[9]
        type = data[10]
        region = data[11]
        country = data[12]
        beginConsume = data[13]
        endConsume = data[14]
    }
}

var fields = [Int]()
var dataArray = [[String]]()
var producer = [Producers]()
var wine = [Wines]()
var bin = [StorageBins]()
var designation: String = ""

struct StorageBins: Codable {
    
    var binName: String?
    var bottleCount: Int?
    var binLocation: String?
    
    static func fetchWineInventory(_ completionHandler: @escaping (WineInventory) -> ()) {
        
        //***
        
        do {
            guard let fileURL = Bundle.main.url(forResource: "bottles1", withExtension: "csv") else { fatalError() }
            var data = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            
            data = data.replacingOccurrences(of: "Unknown", with: "")

            dataArray = parseCsv(data)

            let dataHeader = dataArray.removeFirst()
            
            let fieldsWeCareAbout: [String] = ["Vintage","Varietal","iWine","Producer","Location","Bin","Vineyard","Designation","Appellation","Locale","Type","Region","Country","BeginConsume","EndConsume"]

            for field in fieldsWeCareAbout{
                if let i = dataHeader.firstIndex(where: { $0 == field }) {
                    fields.append(i)
                }
            }
            
        } catch {
            print(error)
        }

        let positionOf = Label(data:fields)
        var locationBin: String
        var checkLocation: [StorageBins]
        
        for row in dataArray{
            locationBin = row[positionOf.location] + row[positionOf.bin]
            
            if let producerIndex = producer.firstIndex(where: { $0.name == row[positionOf.producer] }) {
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
                } else {
                    // new wine for existing producer
                    wine.removeAll()
                    wine.append(Wines(iWine: row[positionOf.iWine],
                                      varietal: row[positionOf.varietal],
                                      vineyard: row[positionOf.vineyard],
                                      vintage: row[positionOf.vintage],
                                      designation: row[positionOf.designation],
                                      ava: row[positionOf.ava],
                                      region: row[positionOf.region],
                                      country: row[positionOf.country],
                                      locale: row[positionOf.locale],
                                      type: row[positionOf.type],
                                      drinkBy: buildDrinkBy(beginConsume: row[positionOf.beginConsume],endConsume: row[positionOf.endConsume]),
                                      storageBins: bin))
                    producer[producerIndex].wines!.append(contentsOf:wine)
                }

            } else {
                // new producer
                wine.removeAll()
                bin.removeAll()
                addNewStorage(binName: row[positionOf.bin], binLocation: row[positionOf.location], bin: &bin)
                wine.append(Wines(iWine: row[positionOf.iWine],
                                  varietal: row[positionOf.varietal],
                                  vineyard: row[positionOf.vineyard],
                                  vintage: row[positionOf.vintage],
                                  designation: row[positionOf.designation],
                                  ava: row[positionOf.ava],
                                  region: row[positionOf.region],
                                  country: row[positionOf.country],
                                  locale: row[positionOf.locale],
                                  type: row[positionOf.type],
                                  drinkBy: buildDrinkBy(beginConsume: row[positionOf.beginConsume],endConsume: row[positionOf.endConsume]),
                                  storageBins: bin))
                producer.append(Producers(name: row[positionOf.producer], isExpanded: false, wines: wine))
            }

        }

        var wineInventory = [WineInventory]()
        let newInventory = WineInventory(producers: producer)
        wineInventory.append(newInventory)
        
        producer = producer.sorted {
            var isSorted = false
            if let first = $0.name, let second = $1.name {
                isSorted = first < second
            }
            return isSorted
        }
        
        do {
            var wineInventory = [WineInventory]()
            let newInventory = WineInventory(producers: producer)
            wineInventory.append(newInventory)

                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(newInventory)
                })

        } catch let err {
            print(err)
        }

        
//        do {
//            let decoder = JSONDecoder()
//
//            let jsonData = try JSONEncoder().encode(newInventory)
//            let jsonString = String(data: jsonData, encoding: .utf8)!
//
//        } catch let err {
//            print(err)
//        }
        
        
        
        //***
        
//        let urlString = "http://localhost/angular/git/wine/resources/dataservices/test.php?rows=1"
//
//        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
//
//            guard let data = data else {
//                return
//            }
//
//            if let error = error {
//                print(error)
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let wineInventory = try decoder.decode(WineInventory.self, from: data)
//
////                DispatchQueue.main.async(execute: { () -> Void in
////                    completionHandler(wineInventory)
////                })
//
//            } catch let err {
//                print(err)
//            }
//
//        }) .resume()
        
    }
    
}

func parseCsv(_ data: String) -> [[String]] {
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

func addNewStorage(binName: String, binLocation: String, bin: inout [StorageBins]) {
    let storage = StorageBins(binName:binName, bottleCount:1, binLocation:binLocation)
    bin.append(storage)
}

func buildDrinkBy(beginConsume: String, endConsume: String) -> String{
    
    let drinkBy: String

    if (beginConsume == "" && endConsume == "") {
        drinkBy = ""
    }
    else if (beginConsume == "" && endConsume != "") {
        drinkBy = "before " + endConsume
    }
    else {
        drinkBy = beginConsume + " - " + endConsume
    }
    return drinkBy
}
