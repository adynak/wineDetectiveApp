//
//  apiService.swift
//  WineGPSWidgetExtension
//
//  Created by adynak on 9/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

class WidgetAPI {
    
    static func load() -> [String: Int] {
        
        var wineCounts = [String: Int]()
        wineCounts = WidgetAPI.readVarietalJson()
        return wineCounts
        
    }
    
    static func readVarietalJson() -> [String: Int] {
        
        var wineCounts = [String: Int]()

        let url = AppGroup.wineGPS.containerURL.appendingPathComponent("varietals.txt")
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let varietalArray = try decoder.decode([WidgetVarietals].self, from: data)
                for varietal in varietalArray{
                    wineCounts[varietal.name] = varietal.quantity
                }
            } catch {
                print("error:\(error)")
                wineCounts["Total Bottles"] = 0
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
