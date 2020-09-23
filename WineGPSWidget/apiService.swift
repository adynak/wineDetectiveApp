//
//  apiService.swift
//  WineGPSWidgetExtension
//
//  Created by adynak on 9/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

class API {
    
    static func load() -> [Int] {
        
        var wineCounts: [Int] = []
        
        do {

            let user = "al00p"
            let pword = "Genesis13355Tigard"
            
            let dataUrl = DataServices.getDataUrl(user: user,
                                                  pword: pword,
                                                  table: "Inventory")
            
            do {

                let data = try fetchRemoteDataAsyncAwait(url: dataUrl)
                let csvInventory = String(data: data!, encoding: String.Encoding.ascii)
                var inventoryArray = DataServices.parseCsv(data:csvInventory!.replacingOccurrences(of: "Unknown", with: ""))

                dataHeader = inventoryArray.removeFirst()
                fields = DataServices.locateDataPositions(dataHeader:dataHeader)
                let positionOf = Label(data:fields)
                
                var wines: [DrillBottle] = []
//                print(inventoryArray[0])
                
                for row in inventoryArray{
                    let vintage = (row[positionOf.vintage] == "1001") ? "NV" : row[positionOf.vintage]

                    let bottle = DrillBottle(
                        producer: row[positionOf.producer],
                        varietal: row[positionOf.varietal],
                        location: row[positionOf.location],
                        bin: row[positionOf.bin],
                        vintage: vintage,
                        iWine: row[positionOf.iWine],
                        barcode: row[positionOf.barcode],
                        designation: row[positionOf.designation],
                        ava: row[positionOf.ava],
                        beginConsume: row[positionOf.beginConsume],
                        endConsume: row[positionOf.endConsume],
                        description: "123",
                        vineyard: row[positionOf.vineyard],
                        type: row[positionOf.type]
                    )
                    
                    wines.append(bottle)

                }
                
                let reds = Dictionary(grouping: wines, by: { $0.type!.lowercased().contains("red") })
                let whites = Dictionary(grouping: wines, by: { $0.type!.lowercased().contains("white") })
                print(wines.count)
                print (reds[true]!.count)
                print (whites[true]!.count)
            
                wineCounts.append(wines.count)
                wineCounts.append(reds[true]!.count)
                wineCounts.append(whites[true]!.count)

            } catch {
                print(error)
            }

        }

        return wineCounts
        
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

}
