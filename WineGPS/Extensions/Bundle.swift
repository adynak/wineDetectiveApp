//
//  Bundle.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation


extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var buildNumberPretty: String {
        return "build \(buildNumber ?? "1.0.0")"
    }
    var versionNumberPretty: String {
        return "v\(versionNumber ?? "1.0.0")"
    }
    
    var versionAndBuildPretty: String{
        return "\(versionNumberPretty) \(buildNumberPretty)"
    }
}
