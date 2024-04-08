//
//  Rate+CoreDataClass.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 07/04/24.
//
//

import Foundation
import CoreData

@objc(Rate)
public class Rate: NSManagedObject {

}


extension Rate {
    func set(code: String, rate: Double, symbol: String) {
        self.code = code
        self.rate = rate
        self.symbol = symbol
    }
    func displayPrice(for amount: Double = 1) -> String {
        return String(format: "\(symbol) %.2f", rate * amount)
    }
    
}
