//
//  Date.swift
//  WineGPS
//
//  Created by adynak on 11/14/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

