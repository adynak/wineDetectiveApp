//
//  DataServices.swift
//  WineGPSWidgetExtension
//
//  Created by adynak on 9/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

var debug: Bool = false

enum NetworkError: Error {
    case url
    case server
    case statusCode
    case standard
}

public enum AppGroup: String {
  case wineGPS = "group.adynak.wineGPS"

  public var containerURL: URL {
    switch self {
    case .wineGPS:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}

class WidgetVarietals : Decodable {
    var name : String
    var quantity : Int

    init (name : String, quantity: Int){
         self.name = name
         self.quantity = quantity
    }
}


var dataHeader = [String]()
var fields = [Int]()
var varietals = [VarietalDetails]()


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

struct DrillBottle {
    let producer: String
    let varietal: String
    let location: String
    let bin: String
    let vintage: String
    let iWine: String
    let barcode: String
    let designation: String
    let ava: String
    let beginConsume: String
    let endConsume: String
    let description: String?
    let vineyard: String?
    let type: String?
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
    }
}


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
    
}
