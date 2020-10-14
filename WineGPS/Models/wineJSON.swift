//
//  wineJSON.swift
//  WineGPS
//
//  Created by adynak on 10/8/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

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
