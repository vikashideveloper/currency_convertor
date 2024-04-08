//
//  Currency+CoreDataProperties.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 07/04/24.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String
    @NSManaged public var name: String

}

extension Currency : Identifiable {

}
