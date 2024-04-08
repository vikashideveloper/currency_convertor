//
//  Rate+CoreDataProperties.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 07/04/24.
//
//

import Foundation
import CoreData


extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var code: String
    @NSManaged public var rate: Double
    @NSManaged public var symbol: String

}

extension Rate : Identifiable {

}
