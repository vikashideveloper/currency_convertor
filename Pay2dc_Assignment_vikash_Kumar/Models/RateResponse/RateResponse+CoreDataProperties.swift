//
//  RateResponse+CoreDataProperties.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 07/04/24.
//
//

import Foundation
import CoreData


extension RateResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RateResponse> {
        return NSFetchRequest<RateResponse>(entityName: "RateResponse")
    }

    @NSManaged public var timestamp: Int64
    @NSManaged public var base: String
    @NSManaged public var rates: NSSet

}

// MARK: Generated accessors for rates
extension RateResponse {

    @objc(insertObject:inRatesAtIndex:)
    @NSManaged public func insertIntoRates(_ value: Rate, at idx: Int)

    @objc(removeObjectFromRatesAtIndex:)
    @NSManaged public func removeFromRates(at idx: Int)

    @objc(insertRates:atIndexes:)
    @NSManaged public func insertIntoRates(_ values: [Rate], at indexes: NSIndexSet)

    @objc(removeRatesAtIndexes:)
    @NSManaged public func removeFromRates(at indexes: NSIndexSet)

    @objc(replaceObjectInRatesAtIndex:withObject:)
    @NSManaged public func replaceRates(at idx: Int, with value: Rate)

    @objc(replaceRatesAtIndexes:withRates:)
    @NSManaged public func replaceRates(at indexes: NSIndexSet, with values: [Rate])

    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: Rate)

    @objc(removeRatesObject:)
    @NSManaged public func removeFromRates(_ value: Rate)

    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSOrderedSet)

    @objc(removeRates:)
    @NSManaged public func removeFromRates(_ values: NSOrderedSet)

}

extension RateResponse : Identifiable {

}
