//
//  wineJSON.swift
//  WineGPS
//
//  Created by adynak on 10/8/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

class WidgetVarietals : Codable {
    var name : String
    var bottleCount : Int

    init (name : String, bottleCount: Int){
         self.name = name
         self.bottleCount = bottleCount
    }
}
