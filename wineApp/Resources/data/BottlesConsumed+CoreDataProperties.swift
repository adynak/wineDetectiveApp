//
//  BottlesConsumed+CoreDataProperties.swift
//  wineApp
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//
//

import Foundation
import CoreData


extension BottlesConsumed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BottlesConsumed> {
        return NSFetchRequest<BottlesConsumed>(entityName: "BottlesConsumed")
    }

    @NSManaged public var iWine: String?
    @NSManaged public var barcode: String?
    @NSManaged public var consumed: Date?

}
