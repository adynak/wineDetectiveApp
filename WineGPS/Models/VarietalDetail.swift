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
        self.name = name
        self.description = description
        self.count = varietalCount
        self.url = URL(string: "WineGPS://varietals/\(description)")
    }
}

extension VarietalDetails: Identifiable {
    public var id: String {
        name
    }
}
