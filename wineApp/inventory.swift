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
    let drinkBy: String?
    let locale: String?
    let region: String?
    let country: String?
    let type: String?
    let vineyard: String?
    var storageBins: [StorageBins]?
}

struct StorageBins: Decodable {
    
    var binName: String?
    var bottleCount: Int?
    var binLocation: String?
    
    static func fetchWineInventory(_ completionHandler: @escaping (WineInventory) -> ()) {
        
        let urlString = "http://localhost/angular/git/wine/resources/dataservices/test.php?rows=500"
        
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
