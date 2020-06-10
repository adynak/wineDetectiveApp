//
//  API.swift
//  wineApp
//
//  Created by adynak on 6/10/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

class API {
    
    static func load() {
        print("load")
        DispatchQueue.global(qos: .utility).async {
            let result = availabilityAPICall()
                .flatMap { inventoryAPICall($0) }

            DispatchQueue.main.async {
                switch result {
                case let .success(data):
//                    for row in data{
//                        print(row)
//                    }
                    dataArray = data
                    break
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    static func availabilityAPICall() -> Result<[[String]], NetworkError> {
        print("availabilityAPICall")
        
        let user = UserDefaults.standard.getUserName()
        let pword = UserDefaults.standard.getUserPword()
        
        let dataUrl = DataServices.getDataUrl(user: user,pword: pword, table: "Availability")

        let path = "http://10.0.1.9/angular/git/wine/resources/dataservices/csv.php?User=&Password=&Format=csv&Table=Availability&Location=1"

        guard let url = URL(string: dataUrl) else {
            return .failure(.url)
        }
        var result: Result<[[String]], NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                var csvAvailability = String(data: data, encoding: .ascii)
                csvAvailability = csvAvailability!.replacingOccurrences(of: "Unknown", with: "")
                availabilityArray = DataServices.parseCsv(data:csvAvailability!)

                result = .success(availabilityArray)
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)

        return result
    }

    static func inventoryAPICall(_ param: [[String?]]) -> Result<[[String]], NetworkError> {
        print("inventoryAPICall")
        var iWine = String()
        
        let user = UserDefaults.standard.getUserName()
        let pword = UserDefaults.standard.getUserPword()
        
        let dataUrl = DataServices.getDataUrl(user: user,pword: pword, table: "Inventory")

//        let path = "http://10.0.1.9/angular/git/wine/resources/dataservices/csv.php?User=&Password=&Format=csv&Table=Inventory&Location=1"

        guard let url = URL(string: dataUrl) else {
            return .failure(.url)
        }
        var result: Result<[[String]], NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                var csvInventory = String(data: data, encoding: .ascii)
                csvInventory = csvInventory!.replacingOccurrences(of: "Unknown", with: "")
                inventoryArray = DataServices.parseCsv(data:csvInventory!)
                
                availabilityHeader = param[0]
                let availibilityFields = DataServices.locateAvailabilityFields(availabilityHeader:availabilityHeader)
                let positionOf = Availability(data:availibilityFields)
                var drinkByFields = availibilityFields
                drinkByFields.removeFirst()
                
                for fieldIndex in drinkByFields{
                    inventoryArray[0].append(param[0][fieldIndex]!)
                }
                                
                if let iWineIndex = inventoryArray[0].firstIndex(of: "iWine") {
                    for (index,row) in inventoryArray.enumerated() where index > 0{
                        iWine = row[iWineIndex]
                        if let availibilityIndex = param.firstIndex(where: { $0[positionOf.iWine] == iWine }){
                            for fieldIndex in drinkByFields{
                                inventoryArray[index].append(param[availibilityIndex][fieldIndex]!)
                            }
                        }
                        
                    }

                }
                
                result = .success(inventoryArray)
                
            } else {
                result = .failure(.server)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)

        return result
    }

}
