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
        let user: String = "al00p"
        let pword: String = "Genesis13355Tigard"
        
        let dataUrl = DataServices.getDataUrl(user: user,pword: pword)

        URLSession.shared.dataTask(with: URL(string: dataUrl)!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                return
            }
            
            if let error = error {
                print(error)
                return
            }

            do {
                var csvData = String(data: data, encoding: .ascii)
                csvData = csvData!.replacingOccurrences(of: "Unknown", with: "")
                dataArray = DataServices.parseCsv(data:csvData!)
                let dataHeader = dataArray.removeFirst()
                let fields = DataServices.locateDataPositions(dataHeader:dataHeader)
                DataServices.buildProducersArray(fields: fields)
                
                var wineInventory = [WineInventory]()
                let newInventory = WineInventory(producers: producer)
                wineInventory.append(newInventory)

                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(newInventory)
                })
                
            } catch let err {
                print(err)
            }

        }) .resume()

    }
    
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
