//
//  API.swift
//  wineApp
//
//  Created by adynak on 6/10/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

//var availabilityArray = [[String]]()


class API {
    
    static func load() {
        print("load")

        do {

            let user = UserDefaults.standard.getUserName()
            let pword = UserDefaults.standard.getUserPword()
            
            let dataUrl = DataServices.getDataUrl(user: user,
                                                  pword: pword,
                                                  table: "Availability")

            let data = try fetchRemoteDataAsyncAwait(url: dataUrl)
            
            var csvAvailability = String(decoding: data!, as: UTF8.self)
            
            csvAvailability = csvAvailability.replacingOccurrences(of: "Unknown", with: "")
            availabilityArray = DataServices.parseCsv(data:csvAvailability)
            
            print("availability")
        } catch {
            print("Failed to fetch availability:", error)
            return
        }
        
        do {
            
            let user = UserDefaults.standard.getUserName()
            let pword = UserDefaults.standard.getUserPword()
            
            let dataUrl = DataServices.getDataUrl(user: user,
                                                  pword: pword,
                                                  table: "Inventory")

            let data = try fetchRemoteDataAsyncAwait(url: dataUrl)
            
            var csvInventory = String(decoding: data!, as: UTF8.self)
            csvInventory = csvInventory.replacingOccurrences(of: "Unknown", with: "")
            inventoryArray = DataServices.parseCsv(data:csvInventory)
            availabilityHeader = availabilityArray[0]
            
            let availibilityFields = DataServices.locateAvailabilityFields(availabilityHeader:availabilityHeader)
            let positionOf = Availability(data:availibilityFields)
            var drinkByFields = availibilityFields
            drinkByFields.removeFirst()
            
            for fieldIndex in drinkByFields{
                inventoryArray[0].append(availabilityArray[0][fieldIndex])
            }
                            
            if let iWineIndex = inventoryArray[0].firstIndex(of: "iWine") {
                for (index,row) in inventoryArray.enumerated() where index > 0{
                    let iWine = row[iWineIndex]
                    if let availibilityIndex = availabilityArray.firstIndex(where: { $0[positionOf.iWine] == iWine }){
                        for fieldIndex in drinkByFields{
                            inventoryArray[index].append(availabilityArray[availibilityIndex][fieldIndex])
                        }
                    }
                    
                }

            }

            dataArray = inventoryArray
            print("inventory")
            print("debug = \(debug)")
            
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
            
            print("build data arrays complete")
            allWine = newInventory

        } catch {
            print("Failed to fetch inventory:", error)
            return
        }

    }
    
    enum NetworkError: Error {
        case url
        case statusCode
        case standard
        case server
    }
    
    static func fetchRemoteDataAsyncAwait(url:String) throws -> Data? {
        guard let remoteURL = URL(string: url) else {
            throw NetworkError.url
        }
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        // Semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: remoteURL) { (d, r, e) in
            data = d
            response = r
            error = e
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode > 300 {
            throw NetworkError.statusCode
        }
        
        if error != nil {
            throw NetworkError.standard
        }
        
        return data
    }
    
//    static func availabilityAPICall() -> Result<[[String]], NetworkError> {
//        print("availabilityAPICall")
//
//        let user = UserDefaults.standard.getUserName()
//        let pword = UserDefaults.standard.getUserPword()
//
//        let dataUrl = DataServices.getDataUrl(user: user,pword: pword, table: "Availability")
//
//        guard let url = URL(string: dataUrl) else {
//            return .failure(.url)
//        }
//        var result: Result<[[String]], NetworkError>!
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            if let data = data {
//                var csvAvailability = String(data: data, encoding: .utf8)
//                csvAvailability = csvAvailability!.replacingOccurrences(of: "Unknown", with: "")
//                availabilityArray = DataServices.parseCsv(data:csvAvailability!)
//
//                result = .success(availabilityArray)
//            } else {
//                result = .failure(.server)
//            }
//            semaphore.signal()
//        }.resume()
//
//        _ = semaphore.wait(wallTimeout: .distantFuture)
//
//        return result
//    }
//
//    static func inventoryAPICall(_ param: [[String?]]) -> Result<[[String]], NetworkError> {
//        print("inventoryAPICall")
//        var iWine = String()
//
//        let user = UserDefaults.standard.getUserName()
//        let pword = UserDefaults.standard.getUserPword()
//
//        let dataUrl = DataServices.getDataUrl(user: user,pword: pword, table: "Inventory")
//
//        guard let url = URL(string: dataUrl) else {
//            return .failure(.url)
//        }
//        var result: Result<[[String]], NetworkError>!
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            if let data = data {
//                var csvInventory = String(data: data, encoding: .utf8)
//                csvInventory = csvInventory!.replacingOccurrences(of: "Unknown", with: "")
//                inventoryArray = DataServices.parseCsv(data:csvInventory!)
//
//                availabilityHeader = param[0]
//                let availibilityFields = DataServices.locateAvailabilityFields(availabilityHeader:availabilityHeader)
//                let positionOf = Availability(data:availibilityFields)
//                var drinkByFields = availibilityFields
//                drinkByFields.removeFirst()
//
//                for fieldIndex in drinkByFields{
//                    inventoryArray[0].append(param[0][fieldIndex]!)
//                }
//
//                if let iWineIndex = inventoryArray[0].firstIndex(of: "iWine") {
//                    for (index,row) in inventoryArray.enumerated() where index > 0{
//                        iWine = row[iWineIndex]
//                        if let availibilityIndex = param.firstIndex(where: { $0[positionOf.iWine] == iWine }){
//                            for fieldIndex in drinkByFields{
//                                inventoryArray[index].append(param[availibilityIndex][fieldIndex]!)
//                            }
//                        } else {
//                            print("WTF")
//                        }
//
//                    }
//
//                }
//
//                result = .success(inventoryArray)
//
//            } else {
//                result = .failure(.server)
//            }
//            semaphore.signal()
//        }.resume()
//
//        _ = semaphore.wait(wallTimeout: .distantFuture)
//
//        return result
//    }

}
