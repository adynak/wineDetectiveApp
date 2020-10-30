//
//  VarietalDetail.swift
//  WineGPS
//
//  Created by adynak on 9/24/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

public struct VarietalDetails {
    public let name: String
    public let description: String
    public let count: Int?
    public let url: URL?
    

    init(name: String, description: String, varietalCount: Int) {
        
        let encodedVarietal = description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        self.name = name
        self.description = description
        self.count = varietalCount
        self.url = URL(string: "WineGPS://WineGPS/varietals?varietal=\(encodedVarietal!)")
    }
}

extension VarietalDetails: Identifiable {
    public var id: String {
        name
    }
}
