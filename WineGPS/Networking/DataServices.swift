//
//  DataServices.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import WidgetKit

let debug: Bool = true

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
    
    static func getDataUrl(user: String, pword: String, table: String) -> String{
        
        struct URL {
            let scheme: String
            let host: String
            let path: String
            
        }
        var urlComponents = URLComponents()

        var url: URL
        if (debug == true){
//            url = URL.init(scheme: "http", host: "73.25.25.100", path: "/wine/resources/dataservices/csv.php")
//            urlComponents.port = 88
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
    
    static func buildVarietal( row: [String], positionOf: Label) -> String{
        
        var varietal = row[positionOf.varietal]
        let type = row[positionOf.type]
                
        if (type.localizedCaseInsensitiveContains("Ros")) {
            if(varietal.contains("Ros")) {

            } else {
                varietal = type + " of " + varietal
            }
        }

        return varietal
    }
    
    static func buildAvailabilityVarietal( row: [String], positionOfVarietal: Int, positionOfType: Int) -> String{
        
        var varietal = row[positionOfVarietal]
        let type = row[positionOfType]
                
        if (type.localizedCaseInsensitiveContains("Ros")) {
            if(varietal.contains("Ros")) {

            } else {
                varietal = type + " of " + varietal
            }
        }

        return varietal
    }
    
    static func buildDrillIntoBottlesArray(fields:[Int], sortKeys: [String], missingOnly: Bool)->[DrillLevel0]{
        
        let positionOf = Label(data:fields)
                
        let mirror = Mirror(reflecting: positionOf)
        var sortIndex0: Int = 0
        var sortIndex1: Int = 0
        
        var level0: [DrillLevel0] = []
        var level1: [DrillLevel1] = []
        var level2: [DrillLevel2] = []
        
        var name: String = ""
        var iWine: String = ""
        var desc: String = ""

        var bottleCount: Int = 0
        
        for child in mirror.children  {
            if child.label == sortKeys[0]{
                sortIndex0 = child.value as! Int
            }
        }
        
        for child in mirror.children  {
            if child.label == sortKeys[1]{
                sortIndex1 = child.value as! Int
            }
        }

        var wines: [DrillBottle] = []
        
        for row in dataArray{
            let vintage = (row[positionOf.vintage] == "1001") ? "NV" : row[positionOf.vintage]

            let bottle = DrillBottle(
                producer: row[positionOf.producer],
                varietal: row[positionOf.wdVarietal],
                location: row[positionOf.location],
                bin: row[positionOf.bin],
                vintage: vintage,
                iWine: row[positionOf.iWine],
                barcode: row[positionOf.barcode],
                available: row[positionOf.available],
                linear: row[positionOf.linear],
                bell: row[positionOf.bell],
                early: row[positionOf.early],
                late: row[positionOf.late],
                fast: row[positionOf.fast],
                twinpeak: row[positionOf.twinpeak],
                simple: row[positionOf.simple],
                designation: row[positionOf.designation],
                ava: row[positionOf.ava],
                beginConsume: row[positionOf.beginConsume],
                endConsume: row[positionOf.endConsume],
                sortKey0: row[sortIndex0],
                sortKey1: row[sortIndex1],
                description: "123",
                vineyard: row[positionOf.vineyard],
                type: row[positionOf.type]
            )
            
            if missingOnly {
                if row[positionOf.beginConsume] == "" && row[positionOf.endConsume] == ""{
                    wines.append(bottle)
                }
            } else {
                wines.append(bottle)
            }
        }
        
        
//        let reds = Dictionary(grouping: wines, by: { $0.type!.lowercased().contains("red") })
//        let whites = Dictionary(grouping: wines, by: { $0.type!.lowercased().contains("white") })
//        print(wines.count)
//        print (reds[true]!.count)
//        print (whites[true]!.count)
//        
//        let wineTypes = Dictionary(grouping: wines, by: { (element: DrillBottle) in
//            return element.type
//        })
//        
//        for (type) in wineTypes {
//            print("\(type.key!) : \(wineTypes[type.key]!.count)")
//        }

        let groupLevel0 = Dictionary(grouping: wines, by: { $0.sortKey0 })

        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.sortKey1 })
            for (item1) in groupLevel1{
                let groupLevel2 = Dictionary(grouping: item1.value, by: { $0.sortKey1 })
                for (item2) in groupLevel2{
                    for (detail) in item2.value {
                        bottleCount += 1
                        var sortKey = designation == "" ? detail.ava : "\(detail.designation) \(detail.ava)"
                        sortKey = "\(detail.vintage) \(sortKey)"
                                                
                        if detail.ava == detail.designation{
                            desc = detail.vineyard!
                        } else {
                            desc = detail.designation + " " + detail.vineyard!
                        }
                        desc = desc.condensedWhitespace
                        
                        level2.append(DrillLevel2(producer: detail.producer,
                                             varietal: detail.varietal,
                                             vintage: detail.vintage,
                                             iWine: detail.iWine,
                                             location: detail.location,
                                             bin: detail.bin,
                                             barcode: detail.barcode,
                                             designation: detail.designation,
                                             ava: detail.ava,
                                             sortKey: sortKey,
                                             beginConsume: detail.beginConsume,
                                             endConsume: detail.endConsume,
                                             bottleCount: 1,
                                             description: desc))
                    }
                    
                    level2 =  level2.sorted(by: {
                        ($0.sortKey!.lowercased()) < ($1.sortKey!.lowercased())
                    })
                                        
                    if missingOnly {
                        for detail in level2 {
                            if iWine != detail.iWine {
                                if detail.designation == "" {
                                    name = "\(detail.vintage!) \(detail.varietal!)"
                                } else {
                                    name = "\(detail.vintage!) \(detail.designation!) \(detail.varietal!)"
                                    name = removeDuplicates(source: name.components(separatedBy: " ")).joined(separator:" ")
                                }
                                level1.append(DrillLevel1(name: name, bottleCount: level2.count, data: level2))
                                iWine = detail.iWine!
                            }
                        }
                    } else {
                        level1.append(DrillLevel1(name: item1.key, bottleCount: level2.count, data: level2))

                    }
                    level2.removeAll()
                }
            }
            
            level1 =  level1.sorted(by: {
                ($0.name!.lowercased()) < ($1.name!.lowercased())
            })
            level0.append(DrillLevel0(name: item0.key, bottleCount: bottleCount, data: level1))
            bottleCount = 0
            level1.removeAll()

        }

        level0 =  level0.sorted(by: {
            ($0.name!.lowercased()) < ($1.name!.lowercased())
        })

        return level0
    }
        
    static func buildAllBottlesArray(fields:[Int])->[AllLevel0]{
        
        var level0: [AllLevel0] = []
        var level1: [AllLevel1] = []
        var wines: [Bottle] = []
        var label: [BottleDetail] = []
        let positionOf = Label(data:fields)
        
        for row in dataArray{
            let bottleSort = row[positionOf.wdVarietal] + " " + row[positionOf.vintage] + " " + row[positionOf.producer] + row[positionOf.iWine]
            
            let binSort = row[positionOf.location] + row[positionOf.bin]
            let bottle = Bottle(producer: row[positionOf.producer], varietal: row[positionOf.wdVarietal], location: row[positionOf.location], bin: row[positionOf.bin], vintage: row[positionOf.vintage], iWine: row[positionOf.iWine], barcode: row[positionOf.barcode], available: row[positionOf.available], linear: row[positionOf.linear], bell: row[positionOf.bell], early: row[positionOf.early], late: row[positionOf.late], fast: row[positionOf.fast], twinpeak: row[positionOf.twinpeak], simple: row[positionOf.simple], beginConsume: row[positionOf.beginConsume], endConsume: row[positionOf.endConsume], sortKey: "", ava: row[positionOf.ava], designation: row[positionOf.designation], bottleSort: bottleSort, binSort: binSort, region: row[positionOf.region], country: row[positionOf.country], vineyard: row[positionOf.vineyard], locale: row[positionOf.locale], type: row[positionOf.type])
            wines.append(bottle)
        }
        
        let groupLevel0 = Dictionary(grouping: wines, by: { $0.bottleSort })
        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.iWine })
            for (item1) in groupLevel1{
                for (detail) in item1.value {
                    level1.append(AllLevel1(
                        location: detail.location,
                        bin: detail.bin,
                        barcode: detail.barcode,
                        binSort: detail.binSort,
                        iwine: detail.iWine))
                }
                level1 =  level1.sorted(by: {
                    ($0.binSort.lowercased()) < ($1.binSort.lowercased())
                })
            }
            for (item) in item0.value {
                let vintage = (item.vintage == "1001") ? "NV" : item.vintage

                label.append(BottleDetail(vvp: item.varietal + " " +
                                               vintage + " " +
                                               item.producer,
                                          vintage: vintage,
                                          varietal: item.varietal,
                                          producer: item.producer,
                                          vineyard: item.vineyard,
                                          ava: item.ava,
                                          designation: item.designation,
                                          region: item.ava,
                                          country: item.country,
                                          locale: item.locale,
                                          type: item.type,
                                          drinkBy: buildDrinkBy(beginConsume: item.beginConsume, endConsume: item.endConsume),
                                          available: item.available.floatValue,
                                          linear: item.linear.floatValue,
                                          bell: item.bell.floatValue,
                                          early: item.early.floatValue,
                                          late: item.late.floatValue,
                                          fast: item.fast.floatValue,
                                          twinPeak: item.twinpeak.floatValue,
                                          simple: item.simple.floatValue,
                                          bottleCount: level1.count))
                break
            }
            level0.append(AllLevel0(drinkByIndex: "0", label: label, storage: level1))
            level1.removeAll()
            label.removeAll()
        }

        return level0
    }

    static func getPositionOf() -> Label{
        let fields = DataServices.locateDataPositions(dataHeader:dataHeader)
        let positionOf = Label(data:fields)
        return positionOf
    }
    
    static func buildLocationArray(fields:[Int])->[Level0]{
        
        var wines: [Bottle] = []
        let positionOf = Label(data:fields)
        
        for row in dataArray{
                        
            let bottle = Bottle(
                producer: row[positionOf.producer],
                varietal: row[positionOf.varietal],
                location: row[positionOf.location],
                bin: row[positionOf.bin],
                vintage: row[positionOf.vintage],
                iWine: row[positionOf.iWine],
                barcode: row[positionOf.barcode],
                available: row[positionOf.available],
                linear: row[positionOf.linear],
                bell: row[positionOf.bell],
                early: row[positionOf.early],
                late: row[positionOf.late],
                fast: row[positionOf.fast],
                twinpeak: row[positionOf.twinpeak],
                simple: row[positionOf.simple],
                beginConsume: row[positionOf.beginConsume],
                endConsume: row[positionOf.endConsume],
                sortKey: row[positionOf.available],
                ava: row[positionOf.designation],
                designation: row[positionOf.designation],
                bottleSort: "",
                binSort: "",
                region: "",
                country: "",
                vineyard: "",
                locale: "",
                type: ""
            )

            wines.append(bottle)
        }
                
        var level0: [Level0] = []
        var level1: [Level1] = []
        var level2: [Level2] = []
        var bottleCount: Int = 0

        let groupLevel0 = Dictionary(grouping: wines, by: { $0.location })

        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.bin })
            for (item1) in groupLevel1{
                let groupLevel2 = Dictionary(grouping: item1.value, by: { $0.bin })
                for (item2) in groupLevel2{
                    for (detail) in item2.value {
                        bottleCount += 1
                        level2.append(Level2(producer: detail.producer,
                                             varietal: detail.varietal,
                                             vintage: detail.vintage,
                                             iWine: detail.iWine,
                                             location: detail.location,
                                             bin: detail.bin,
                                             barcode: detail.barcode))
                    }
                    
                    level2 =  level2.sorted(by: {
                        ($0.producer!.lowercased()) < ($1.producer!.lowercased())
                    })

                    level1.append(Level1(name: item1.key, bottleCount: level2.count, data: level2))
                    level2.removeAll()
                }
            }
            
            level1 =  level1.sorted(by: {
                ($0.name!.lowercased()) < ($1.name!.lowercased())
            })
            level0.append(Level0(name: item0.key, bottleCount: bottleCount, data: level1))
            bottleCount = 0
            level1.removeAll()

        }

        level0 =  level0.sorted(by: {
            ($0.name!.lowercased()) < ($1.name!.lowercased())
        })

        return level0
    }
    
    static func buildCellarTrackerList() -> [DrillLevel2] {
        var tellCellarTracker = [DrillLevel2]()
        var producer = String()
        var vintage = String()
        var varietal = String()
        var location = String()
        var bin = String()
        
        let inventoryPositionOf = Label(data:fields)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BottlesConsumed")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let barcode = data.value(forKey: "barcode") as! String
                let consumed = formatConsumeDate(consumed: data.value(forKey: "consumed") as! Date)
                
                if let inventoryIndex = inventoryArray.firstIndex(where: { $0[inventoryPositionOf.barcode] == barcode }){
                    producer = inventoryArray[inventoryIndex][inventoryPositionOf.producer]
                    vintage = inventoryArray[inventoryIndex][inventoryPositionOf.vintage]
                    varietal = inventoryArray[inventoryIndex][inventoryPositionOf.varietal]
                    location = inventoryArray[inventoryIndex][inventoryPositionOf.location]
                    bin = inventoryArray[inventoryIndex][inventoryPositionOf.bin]
                    
                    tellCellarTracker.append(DrillLevel2(
                        producer: producer,
                        varietal: varietal,
                        vintage: vintage,
                        location: location,
                        bin: bin,
                        barcode: barcode,
                        consumeDate: consumed))
                } else {
                    API.deleteCoreData(barcode: barcode)
                }
                
            }
        }
        catch {
            
        }
        return tellCellarTracker
    }
    
    static func formatConsumeDate(consumed: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")
        return dateFormatter.string(from: consumed)
    }
        
    static func removeBottles(bottles: [DrillLevel2], writeCoreData: Bool){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
    
        let fields = DataServices.locateDataPositions(dataHeader:dataHeader)
        var dataArrayFiltered = [[String]]()
        
        for bottle in bottles{            
            let barcode = bottle.barcode!.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            let iwine = bottle.iWine!.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            print(barcode + " " + iwine)
            
            if writeCoreData{
                let consumed = BottlesConsumed(entity: BottlesConsumed.entity(), insertInto: context)
                consumed.iWine = iwine
                consumed.barcode = barcode
                consumed.consumed = Date()
                appDelegate!.saveContext()
            }
            
            dataArrayFiltered = dataArray.filter { !$0[1].contains(barcode) }
            dataArray = dataArrayFiltered
        }
                
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
        
        print("rebuild data arrays complete")
        allWine = newInventory
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBottles"), object: nil)
        
        DataServices.writeToDocumentsDirectory(wines: varietalSort)
        
        WidgetCenter.shared.reloadAllTimelines()


    }

    static func locateAvailabilityFields(availabilityHeader: [String?]) -> [Int]{
        
        var fields = [Int]()
        let fieldsWeCareAbout: [String] = ["iWine","Available","Linear","Bell","Early","Late","Fast","TwinPeak","Simple", "wdVarietal"]

        for field in fieldsWeCareAbout{
            if let i = availabilityHeader.firstIndex(where: { $0 == field }) {
                fields.append(i)
            }
        }
        return fields
    }
    
    static func removeDuplicates<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    static func setupTitleView(title: String, subTitle: String ) -> UILabel {
        let topText = title
        let bottomText = subTitle

        let navTitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white,
                               NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]
        let navSubtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                  NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 14)!]

        let navTitle: NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: navTitleParameters)
        let navSubtitle: NSAttributedString = NSAttributedString(string: bottomText, attributes: navSubtitleParameters)

        navTitle.append(NSAttributedString(string: "\n"))
        navTitle.append(navSubtitle)

        let size = navTitle.size()

        let width = size.width
        let navigationController = UINavigationController()
        let height = navigationController.navigationBar.frame.size.height

        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0, width: width, height: height))
        titleLabel.attributedText = navTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }
    
    static func getFieldPositionOf(positionOfKey: String) -> Int {
        var positionOf: Int = 0
        let positionOfFields = getPositionOf()
        
        let mirror = Mirror(reflecting: positionOfFields)

        for (key, value) in mirror.children {
            if key == positionOfKey{
                positionOf = value as! Int
            }
        }
        
        return positionOf
    }
    
    static func findDrinkByIndex(iWine: String, drinkByKey: String) -> String{
        let drinkByPositionOf = getFieldPositionOf(positionOfKey: drinkByKey)
        let row = inventoryArray.firstIndex(where:{$0[0] == iWine})

        guard let drinkByValue = Float(inventoryArray[row!][drinkByPositionOf]) else {
            return "0"
        }
        return String(format: "%.3f", drinkByValue)
    }
    
    static func buildBottleArray(fields: [Int], drinkByKey: String) -> [Bottle]{
        var wines: [Bottle] = []
        let positionOf = Label(data:fields)
        var bottleSort: String = ""
        
        let drinkByPositionOf = getFieldPositionOf(positionOfKey: drinkByKey)
        let iWinePositionOf = getFieldPositionOf(positionOfKey: "iWine")

        for row in dataArray{
            bottleSort = row[drinkByPositionOf]
            
            if bottleSort == "" {
                bottleSort = row[iWinePositionOf]
            }

            let binSort = row[positionOf.location] + row[positionOf.bin]
            let bottle = Bottle(producer: row[positionOf.producer], varietal: row[positionOf.wdVarietal], location: row[positionOf.location], bin: row[positionOf.bin], vintage: row[positionOf.vintage], iWine: row[positionOf.iWine], barcode: row[positionOf.barcode], available: row[positionOf.available], linear: row[positionOf.linear], bell: row[positionOf.bell], early: row[positionOf.early], late: row[positionOf.late], fast: row[positionOf.fast], twinpeak: row[positionOf.twinpeak], simple: row[positionOf.simple], beginConsume: row[positionOf.beginConsume], endConsume: row[positionOf.endConsume], sortKey: "", ava: row[positionOf.ava], designation: row[positionOf.designation], bottleSort: bottleSort, binSort: binSort, region: row[positionOf.region], country: row[positionOf.country], vineyard: row[positionOf.vineyard], locale: row[positionOf.locale], type: row[positionOf.type])
            wines.append(bottle)

            
        }

        return wines
    }
    
    static func buildDrinkByBottlesArray(fields:[Int], drinkByKey: String)->[AllLevel0]{
        
        var level0: [AllLevel0] = []
        var level1: [AllLevel1] = []
        var wines: [Bottle] = []
        var label: [BottleDetail] = []

        wines = buildBottleArray(fields: fields, drinkByKey: drinkByKey)
                
        let groupLevel0 = Dictionary(grouping: wines, by: { $0.bottleSort })
        for (item0) in groupLevel0{
            let groupLevel1 = Dictionary(grouping: item0.value, by: { $0.iWine })
            for (item1) in groupLevel1{
                for (detail) in item1.value {
                    level1.append(AllLevel1(
                        location: detail.location,
                        bin: detail.bin,
                        barcode: detail.barcode,
                        binSort: detail.binSort,
                        iwine: detail.iWine,
                        varietal: detail.varietal))
                }
                level1 =  level1.sorted(by: {
                    ($0.varietal!.lowercased()) < ($1.varietal!.lowercased())
                })
            
                for (item) in item1.value {
                    let vintage = (item.vintage == "1001") ? "NV" : item.vintage

                    label.append(BottleDetail(vvp: item.varietal + " " +
                                                   vintage + " " +
                                                   item.producer,
                                              vintage: vintage,
                                              varietal: item.varietal,
                                              producer: item.producer,
                                              vineyard: item.vineyard,
                                              ava: item.ava,
                                              designation: item.designation,
                                              region: item.ava,
                                              country: item.country,
                                              locale: item.locale,
                                              type: item.type,
                                              drinkBy: buildDrinkBy(beginConsume: item.beginConsume, endConsume: item.endConsume),
                                              available: item.available.floatValue,
                                              linear: item.linear.floatValue,
                                              bell: item.bell.floatValue,
                                              early: item.early.floatValue,
                                              late: item.late.floatValue,
                                              fast: item.fast.floatValue,
                                              twinPeak: item.twinpeak.floatValue,
                                              simple: item.simple.floatValue,
                                              bottleCount: level1.count))
                }
            
                level0.append(AllLevel0(drinkByIndex: "bottleSort", label: label, storage: level1))
                level1.removeAll()
                label.removeAll()
            }
        }

        return level0
    }
    
    static func buildTellCellarTrackerMessage(markAsDrank: [DrillLevel2])->String{
        var message: String = NSLocalizedString("updateCellarTracker", comment: "message that these bottles should be marked drank, replacement text is singular 'this bottle'or plural 'these bottles") + "\n\n"
        var barcode: String = ""
        var vintage: String = ""
        
        let bottleSingular = NSLocalizedString("singularThis", comment: "this wine")
        let pluralBottle = NSLocalizedString("pluralThese", comment: "text replacement for this bottle: these bottles")
        let bottleString = (markAsDrank.count == 1) ? bottleSingular : pluralBottle
        
        message = message.replacingOccurrences(of: "%1", with: bottleString)
        
        for bottle in markAsDrank {
            
            if UserDefaults.standard.getShowBarcode() {
                barcode = "(\(bottle.barcode!.digits))"
            }
            if bottle.vintage == "1001" {
                vintage = "NV"
            } else {
                vintage = bottle.vintage!
            }
            let locationAndBin = NSLocalizedString("labelLocation", comment: "textfield label: Location: similar to a storage room") + ": \(bottle.location!) \(bottle.bin!)"
            message += "\(bottle.consumeDate!)\n  \(bottle.producer!)\n  \(vintage) \(bottle.varietal!)\n  \(locationAndBin) \(barcode)"
        }
        return message
    }

    static func writeToDocumentsDirectory(wines: [DrillLevel0]) {
        
//        print("writeToDocumentsDirectory")
        var totalBottles = 0
        let jsonArray:NSMutableArray = NSMutableArray()

        for bottle in wines
        {
            let varietal: NSMutableDictionary = NSMutableDictionary()
            varietal.setValue(bottle.name, forKey: "name")
            varietal.setValue(bottle.bottleCount, forKey: "quantity")
            jsonArray.add(varietal)
            totalBottles += bottle.bottleCount!
        }
        
        let varietal: NSMutableDictionary = NSMutableDictionary()
        let totalString = NSLocalizedString("totalBottles", comment: "plural : total bottles")

        varietal.setValue(totalString, forKey: "name")
        varietal.setValue(totalBottles, forKey: "quantity")
        jsonArray.insert(varietal, at: 0)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonArray)

        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        let url = AppGroup.wineGPS.containerURL.appendingPathComponent("varietals.txt")
        _ = try?jsonString.write(to: url, atomically: true, encoding: .utf8)
        
//        let wineCounts = readVarietalJson()
//
//
//        var varietalArray = [WidgetVarietals]()
//
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            varietalArray = try decoder.decode([WidgetVarietals].self, from: data)
//            print(varietalArray)
//        } catch {
//            print("error:\(error)")
//        }
//        print("atend")
                
    }
    
//    class WidgetVarietals : Decodable {
//        var name : String
//        var quantity : Int
//
//        init (name : String, quantity: Int){
//             self.name = name
//             self.quantity = quantity
//        }
//    }
    
//    static func readVarietalJson() -> [String: Int] {
//        
//        var wineCounts = [String: Int]()
//
//        let url = AppGroup.wineGPS.containerURL.appendingPathComponent("varietals.txt")
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                let varietalArray = try decoder.decode([WidgetVarietals].self, from: data)
//                for varietal in varietalArray{
//                    wineCounts[varietal.name] = varietal.quantity
//                }                
//            } catch {
//                print("error:\(error)")
//                wineCounts["Total Bottles"] = 0
//            }
//        return wineCounts
//    }

    static func countBottles(bins: [SearchKeys])-> String{
        var totalBottles: Int = 0
        
        for (bin) in bins {
            for (bottles) in bin.storageBins! {
                totalBottles += bottles.bottleCount!
            }
        }
        
        let plural = totalBottles == 1 ? NSLocalizedString("singularBottle", comment: "singular for the word bottle") : NSLocalizedString("pluralBottle", comment: "plural of the word bottle")
        
        return "\(totalBottles)" + plural
    }

    static func endRefreshing(tv: UITableView, rc: UIRefreshControl){
        let top = CGPoint(x: 0, y: -rc.bounds.size.height)
        let rowsInSectionZero = tv.numberOfRows(inSection: 0)
        if rowsInSectionZero == 0 {
            tv.setContentOffset(top, animated: true)
            tv.layoutIfNeeded()
        } else {
            tv.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        } 
        rc.endRefreshing()
    }
}

