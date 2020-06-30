//
//  ExpandableNames.swift
//  wineApp
//
//  Created by adynak on 12/6/18.
//  Copyright © 2018 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

struct Bottle {
    let producer: String
    let varietal: String
    let location: String
    let bin: String
    let vintage: String
    let iWine: String
    let barcode: String
    let available: String
    let linear: String
    let bell: String
    let early: String
    let late: String
    let fast: String
    let twinpeak: String
    let simple: String
    let beginConsume: String
    let endConsume: String
    let sortKey: String
    let ava: String
    let designation: String
    let bottleSort: String
    let binSort: String
    let region: String
    let country: String
    let vineyard: String
    let locale: String
    let type: String
}

struct AllLevel0 {
    var isExpanded: Bool = false
    var label: [bottleDetail]
    var storage: [AllLevel1]
}

struct AllLevel1 {
    var location: String
    var bin: String
    var barcode: String
    var binSort: String
}

struct bottleDetail {
    var vvp: String
    var vintage: String
    var varietal: String
    var producer: String
    var vineyard: String
    var ava: String
    var designation: String
    var region: String
    var country: String
    var locale: String
    var type: String
    var drinkBy: String
    var available: Float
    var linear: Float
    var bell: Float
    var early: Float
    var late: Float
    var fast: Float
    var twinPeak: Float
    var simple: Float
    var bottleCount: Int
}


struct Level0 {
    var name: String?
    var bottleCount: Int?
    var isExpanded: Bool = false
    var data: [Level1]
}

struct Level1 {
    var name: String?
    var bottleCount: Int?
    var data: [Level2]
}

struct Level2 {
    var producer: String?
    var varietal: String?
    var vintage: String?
    var iWine: String?
    var location: String?
    var bin: String?
    var barcode: String?
}

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
    var bottles: [Level2]?
    var location: String?
    var bin: String?
}

struct WineInventory {
    var producers: [Producers]?
    var varietals: [Producers]?
    var drinkBy: [Producers]?
    var reconcile: [Level0]?
    var search: [AllLevel0]?
}

struct Producers: Codable {
    let name: String?
    var isExpanded: Bool?
    var bottleCount: Int?
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
    let producer: String?
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
    let barcode: Int
    let available: Int
    let linear: Int
    let bell: Int
    let early: Int
    let late: Int
    let fast: Int
    let twinpeak: Int
    let simple: Int
//    let sortKey: Int
    
    
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
        barcode = data[15]
        available = data[16]
        linear = data[17]
        bell = data[18]
        early = data[19]
        late = data[20]
        fast = data[21]
        twinpeak = data[22]
        simple = data[23]
//        sortKey = data[24]
    }
}
var fields = [Int]()
var dataArray = [[String]]()
var wine = [Wines]()
var bin = [StorageBins]()
var designation: String = ""
var dataHeader = [String]()

struct StorageBins: Codable {
    var binName: String?
    var bottleCount: Int?
    var binLocation: String?
    var barcode: String?
}

    func fetchWineInventory(_ completionHandler: @escaping (WineInventory) -> ()) {
        
//        API.load()
        
        
        let user = UserDefaults.standard.getUserName()
        let pword = UserDefaults.standard.getUserPword()
        
        var dataUrl = DataServices.getDataUrl(user: user,pword: pword, table: "Inventory")

        URLSession.shared.dataTask(with: URL(string: dataUrl)!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                return
            }
            
            if let error = error {
                print(error)
                return
            }

            do {
                var csvInventory = String(data: data, encoding: .ascii)
                csvInventory = csvInventory!.replacingOccurrences(of: "Unknown", with: "")
                dataArray = DataServices.parseCsv(data:csvInventory!)
                
                dataHeader = dataArray.removeFirst()
                let fields = DataServices.locateDataPositions(dataHeader:dataHeader)
                
                let reconcileSort = DataServices.buildReconcileArray(fields: fields)
                
                let producerSort = DataServices.buildProducersArray(fields: fields,
                                                                    sortKey: "producer")
                
                let varietalSort = DataServices.buildProducersArray(fields: fields,
                                                                    sortKey: "varietal")
                
                let drinkBySort = DataServices.buildProducersArray(fields: fields,
                                                                   sortKey: "drinkBy")
                                
                let newInventory = WineInventory(producers: producerSort,
                                                 varietals: varietalSort,
                                                 drinkBy: drinkBySort,
                                                 reconcile: reconcileSort)

                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(newInventory)
                })
                
            }

        }) .resume()
        
        dataUrl = DataServices.getDataUrl(user: user,pword: pword, table: "Availability")

//        URLSession.shared.dataTask(with: URL(string: dataUrl)!, completionHandler: { (data, response, error) -> Void in
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
//                var csvDrinkBy = String(data: data, encoding: .ascii)
//                
//                let newInventory1 = WineInventory()
//                
//                DispatchQueue.main.async(execute: { () -> Void in
//                    completionHandler(newInventory1)
//                })
//                
//            }
//
//        }) .resume()


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
