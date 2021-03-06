//
//  apiService.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit
import WidgetKit

class API {
    
    static func load(callingView: String) -> String {
                
        Alert.debugPrint(debugMessage: "debug = \(debug)")
        
        if Reachability.isConnectedToNetwork(){
            Alert.debugPrint(debugMessage: "Internet Connection Available!")
        }else{
            Alert.debugPrint(debugMessage: "Internet Connection not Available!")
            return "NoInternet"
        }
        
        if lastRefreshTime == nil || callingView == "login" {
            lastRefreshTime = Date() - 60
        }
            
        if Date() - lastRefreshTime! < 59 {
            return "CancelRefresh"
        } else {
            lastRefreshTime = Date()
        }

        do {

            let user = UserDefaults.standard.getUserName()
            let pword = UserDefaults.standard.getUserPword()
            
            let dataUrl = DataServices.getDataUrl(user: user,
                                                  pword: pword,
                                                  table: "Availability")

            let data = try fetchRemoteDataAsyncAwait(url: dataUrl)
            
            var csvAvailability = String(data: data!, encoding: String.Encoding.ascii)

            csvAvailability = csvAvailability!.replacingOccurrences(of: "Unknown", with: "")
            availabilityArray = DataServices.parseCsv(data:csvAvailability!)
            if availabilityArray[0].firstIndex(of: "iWine") == nil {
                return "Failed"
            }
            availabilityArray[0].append("wdVarietal")
            
            availabilityHeader = availabilityArray[0]
                        
            let positionOfVarietal = availabilityHeader.firstIndex(where:{$0 == "Varietal"})
            let positionOfType = availabilityHeader.firstIndex(where:{$0 == "Type"})
            
            for (index,row) in availabilityArray.enumerated() where index > 0{
                let varietal = DataServices.buildAvailabilityVarietal(row: row, positionOfVarietal: positionOfVarietal!, positionOfType: positionOfType!)
                availabilityArray[index].append(varietal)
                
            }

            Alert.debugPrint(debugMessage: "loading availability")
        } catch {
            Alert.debugPrint(debugMessage: "Failed to fetch availability: \(error)")
            return "Failed"
        }
        
        do {
            
            let user = UserDefaults.standard.getUserName()
            let pword = UserDefaults.standard.getUserPword()
            
            let dataUrl = DataServices.getDataUrl(user: user,
                                                  pword: pword,
                                                  table: "Inventory")

            let data = try fetchRemoteDataAsyncAwait(url: dataUrl)
            
            var csvInventory = String(data: data!, encoding: String.Encoding.ascii)
            
            csvInventory = csvInventory!.replacingOccurrences(of: "Unknown", with: "")
            inventoryArray = DataServices.parseCsv(data:csvInventory!)
            if inventoryArray.count == 0 {
                return "Failed"
            }

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
            Alert.debugPrint(debugMessage: "loading inventory")
            
            dataHeader = dataArray.removeFirst()
            fields = DataServices.locateDataPositions(dataHeader:dataHeader)
            
            let locationSort = DataServices.buildDrillIntoBottlesArray(
                                    fields: fields,
                                    sortKeys: ["location","bin"],
                                    missingOnly: false)

            let searchSort = DataServices.buildAllBottlesArray(fields: fields)
                                                            
            let producerSort = DataServices.buildDrillIntoBottlesArray(
                                    fields: fields,
                                    sortKeys: ["producer","wdVarietal"],
                                    missingOnly: false)
            
            let drinkBySort = DataServices.buildDrinkByBottlesArray(fields: fields, drinkByKey: "available")


            let varietalSort = DataServices.buildDrillIntoBottlesArray(
                                    fields: fields,
                                    sortKeys: ["wdVarietal","producer"],
                                    missingOnly: false)
            
            let missingSort = DataServices.buildDrillIntoBottlesArray(
                                    fields: fields,
                                    sortKeys: ["producer","iWine"],
                                    missingOnly: true)
                                                    
            let newInventory = WineInventory(producers: producerSort,
                                             varietals: varietalSort,
                                             drinkBy: drinkBySort,
                                             search: searchSort,
                                             location: locationSort,
                                             missing: missingSort)
            
            DataServices.writeToDocumentsDirectory(wines: varietalSort)
            
            WidgetCenter.shared.reloadAllTimelines()

            Alert.debugPrint(debugMessage: "build data arrays complete")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "APILoaded"), object: nil)

            allWine = newInventory
            return "Success"

        } catch {
            Alert.debugPrint(debugMessage: "Failed to fetch inventory: \(error)")
            return "Failed"
        }

    }
    
    static func deleteCoreData(barcode: String){
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = PersistentCloudKitContainer.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BottlesConsumed")
        fetchRequest.predicate = NSPredicate(format: "barcode = %@", barcode)
       
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            if test.count != 0 {
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
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
        
//        print(try NSAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string)
//        print(try NSAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).length)

        if error != nil {
            throw NetworkError.standard
        }
        
        return data
    }
    
    static func getiCloudAccountStatus()->String {
        var status: String = ""
        
        if FileManager.default.ubiquityIdentityToken != nil {
            status = "Available"
        } else {
            status = "Unavailable"
        }
        
        CKContainer.default().accountStatus { (accountStatus, error) in
            switch accountStatus {
            case .available:
                status = "iCloud Available"
            case .noAccount:
                status = "No iCloud account"
            case .restricted:
                status = "iCloud restricted"
            case .couldNotDetermine:
                status = "Unable to determine iCloud status"
            @unknown default:
                status = "Unable to determine iCloud status (default)"
            }
        }
        return status
    }

}
