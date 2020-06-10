//
//  ViewController.swift
//  ResultTypeLBTA
//
//  Created by Brian Voong on 4/2/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

//var allWine: WineInventory?


//enum NetworkError: Error {
//    case url
//    case server
//}
//
//var availabilityArray = [[String]]()
//var inventoryArray = [[String]]()
//var availabilityHeader = [String?]()
//
//struct Availability{
//    let iWine: Int
//    let available: Int
//    let linear: Int
//    let bell: Int
//    let early: Int
//    let fast: Int
//    let twinPeak: Int
//    let simple: Int
//
//    init(data: [Int]) {
//        iWine = data[0]
//        available = data[1]
//        linear = data[2]
//        bell = data[3]
//        early = data[4]
//        fast = data[5]
//        twinPeak = data[6]
//        simple = data[7]
//    }
//}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let spinnerText: String = "Cargando"
//        self.showSpinner(text: spinnerText)
//       let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { timer in
//            self.hideSpinner()
//        })
        API.load()
        print("done")
        hideSpinner()
    }
}
    
//    func load() {
//        print("load")
//        DispatchQueue.global(qos: .utility).async {
//            let result = self.availabilityAPICall()
//                .flatMap { self.inventoryAPICall($0) }
//
//            DispatchQueue.main.async {
//                switch result {
//                case let .success(data):
//                    for row in data{
//                        print(row)
//                    }
//                    break
//                case let .failure(error):
//                    print(error)
//                    break
//                }
//            }
//        }
//    }
//
//    func inventoryAPICall(_ param: [[String?]]) -> Result<[[String?]], NetworkError> {
//        print("inventoryAPICall")
//        var iWine = String()
//
//        let path = "http://10.0.1.9/angular/git/wine/resources/dataservices/csv.php?User=&Password=&Format=csv&Table=Inventory&Location=1"
//
//        guard let url = URL(string: path) else {
//            return .failure(.url)
//        }
//        var result: Result<[[String?]], NetworkError>!
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            if let data = data {
//                var csvInventory = String(data: data, encoding: .ascii)
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
//
////                po param.firstIndex(where: { $0[positionOf.iWine] == "2584284" })
//
//                if let iWineIndex = inventoryArray[0].firstIndex(of: "iWine") {
//                    for (index,row) in inventoryArray.enumerated() where index > 0{
//                        iWine = row[iWineIndex]
//                        if let availibilityIndex = param.firstIndex(where: { $0[positionOf.iWine] == iWine }){
//                            for fieldIndex in drinkByFields{
//                                inventoryArray[index].append(param[availibilityIndex][fieldIndex]!)
//                            }
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
//
//    func availabilityAPICall() -> Result<[[String?]], NetworkError> {
//        print("availabilityAPICall")
//        let path = "http://10.0.1.9/angular/git/wine/resources/dataservices/csv.php?User=&Password=&Format=csv&Table=Availability&Location=1"
//
//        guard let url = URL(string: path) else {
//            return .failure(.url)
//        }
//        var result: Result<[[String?]], NetworkError>!
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            if let data = data {
//                var csvAvailability = String(data: data, encoding: .ascii)
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
//}

//var boxView = UIView()
//
//extension UIViewController{
//    
//    func showSpinner(text: String){
//        
//        let logo: UIImageView = {
//            let image = UIImage(named: "logo")
//            let imageView = UIImageView(image: image)
//            let x = view.center.x - CGFloat(70)
//            let y = view.center.y + CGFloat(-200)
//            imageView.frame = CGRect(x: x, y: y, width: 160, height: 160)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            return imageView
//        }()
//        
//        let boxView: UIView = {
//            let box =  UIView()
//            box.frame = CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 100)
//            box.backgroundColor = UIColor(r:80, g:102, b:144)
//            box.alpha = 0.8
//            box.layer.cornerRadius = 10
//            return box
//        }()
//        
//        let text:UILabel = {
//            let label = UILabel()
//            label.frame = CGRect(x: 0, y: 60, width: 180, height: 30)
//            label.textAlignment = .center
//            label.backgroundColor = UIColor(r:80, g:102, b:144)
//            label.textColor = .white
//            label.text = text
//            return label
//        }()
//        
//        let spinner: UIActivityIndicatorView = {
//            let view = UIActivityIndicatorView()
//            view.style = .large
//            view.color = .black
//            view.center = boxView.center
//            view.frame = CGRect(x: 70, y: 10, width: 50, height: 50)
//            view.startAnimating()
//            return view
//        }()
//        
//        view.addSubview(logo)
//        boxView.addSubview(spinner)
//        boxView.addSubview(text)
//                
//        view.addSubview(boxView)
//    }
//    
//    func hideSpinner(){
//        boxView.removeFromSuperview()
//    }
//}
//
//extension UIColor {
//    
//    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
//        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
//    }
//    
//}
//
//extension UIView {
//    
//    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
//        
//        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
//    }
//    
//    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
//        
//        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
//    }
//    
//    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        var anchors = [NSLayoutConstraint]()
//        
//        if let top = top {
//            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
//        }
//        
//        if let left = left {
//            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
//        }
//        
//        if let bottom = bottom {
//            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
//        }
//        
//        if let right = right {
//            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
//        }
//        
//        if widthConstant > 0 {
//            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
//        }
//        
//        if heightConstant > 0 {
//            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
//        }
//        
//        anchors.forEach({$0.isActive = true})
//        
//        return anchors
//    }
//    
//}

//class DataServices {
//
//    static func parseCsv(data: String) -> [[String]]{
//        // data: String = contents of a CSV file.
//        // Returns: [[String]] = two-dimension array [rows][columns].
//        // Data minimum two characters or fail.
//        if data.count < 2 {
//            return []
//        }
//        var a: [String] = [] // Array of columns.
//        var index: String.Index = data.startIndex
//        let maxIndex: String.Index = data.index(before: data.endIndex)
//        var q: Bool = false // "Are we in quotes?"
//        var result: [[String]] = []
//        var v: String = "" // Column value.
//        while index < data.endIndex {
//            if q { // In quotes.
//                if (data[index] == "\"") {
//                    // Found quote; look ahead for another.
//                    if index < maxIndex && data[data.index(after: index)] == "\"" {
//                        // Found another quote means escaped.
//                        // Increment and add to column value.
//                        data.formIndex(after: &index)
//                        v += String(data[index])
//                    } else {
//                        // Next character not a quote; last quote not escaped.
//                        q = !q // Toggle "Are we in quotes?"
//                    }
//                } else {
//                    // Add character to column value.
//                    v += String(data[index])
//                }
//            } else { // Not in quotes.
//                if data[index] == "\"" {
//                    // Found quote.
//                    q = !q // Toggle "Are we in quotes?"
//                } else if data[index] == "\n" || data[index] == "\r\n" {
//                    // Reached end of line.
//                    // Column and row complete.
//                    a.append(v)
//                    v = ""
//                    result.append(a)
//                    a = []
//                } else if data[index] == "," {
//                    // Found comma; column complete.
//                    a.append(v)
//                    v = ""
//                } else {
//                    // Add character to column value.
//                    v += String(data[index])
//                }
//            }
//            if index == maxIndex {
//                // Reached end of data; flush.
//                if v.count > 0 || data[data.index(before: index)] == "," {
//                    a.append(v)
//                }
//                if a.count > 0 {
//                    result.append(a)
//                }
//                break
//            }
//            data.formIndex(after: &index) // Increment.
//        }
//        return result
//    }
//
//    static func locateAvailabilityFields(availabilityHeader: [String?]) -> [Int]{
//
//        var fields = [Int]()
//        let fieldsWeCareAbout: [String] = ["iWine","Available","Linear","Bell","Early","Late","Fast","TwinPeak","Simple"]
//
//        for field in fieldsWeCareAbout{
//            if let i = availabilityHeader.firstIndex(where: { $0 == field }) {
//                fields.append(i)
//            }
//        }
//        return fields
//    }
//
//}
