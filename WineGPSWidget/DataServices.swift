//
//  DataServices.swift
//  WineGPSWidgetExtension
//
//  Created by adynak on 9/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

// be sure that groups is enabled in
//   the target writer (the app)
//   the target reader (the widget and intent)

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

var varietals = [VarietalDetails]()
