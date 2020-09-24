//
//  WineGPSBundle.swift
//  WineGPS
//
//  Created by adynak on 9/24/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation

import SwiftUI
import WidgetKit

@main
struct WineGPSWidgetBundle: WidgetBundle {

  @WidgetBundleBuilder
  var body: some Widget {
    WineGPSWidget()
  }
}

