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
    var ava = "123"
    var designation = "123"
    var bottleCount = "19"
    var storageBins: [StorageBins]?
}

struct WineInventory: Decodable {
    var producers: [Producers]?
}

struct Producers: Decodable {
    let name: String?
    var isExpanded: Bool?
    var wines : [Wines]?
}

struct Wines: Decodable {
    let vintage: String?
    let varietal: String?
    let designation: String?
    let ava: String?
    var storageBins: [StorageBins]?
}

struct StorageBins: Decodable {
    
    var binName: String?
    var bottleCount: Int?
    
    static func fetchWineInventory(_ completionHandler: @escaping (WineInventory) -> ()) {
        
        let urlString = "http://localhost:8000/xcode/dataStore.php"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                return
            }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let wineInventory = try decoder.decode(WineInventory.self, from: data)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(wineInventory)
                })
                
            } catch let err {
                print(err)
            }
            
        }) .resume()
        
    }
    
}
