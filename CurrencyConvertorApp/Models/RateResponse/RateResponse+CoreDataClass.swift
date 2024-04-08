//
//  RateResponse+CoreDataClass.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 07/04/24.
//
//

import Foundation
import CoreData

@objc(RateResponse)
public class RateResponse: NSManagedObject {

}


extension RateResponse {
    func set(json: [String: Any]) {
            if let ratesDic = json["rates"] as? [String : Any],
                let timestamp = json["timestamp"] as? Int64,
                let base = json["base"] as? String {
    
               let rates = ratesDic.map {
                    let symbol = Utility.getSymbolForCurrencyCode(code: $0.key)
                    let rate = Rate(context: self.managedObjectContext!)
                    rate.set(code: $0.key, rate: $0.value as? Double ?? 0, symbol: symbol)
                    return rate
                }
                self.rates = NSSet(array: rates)
                self.timestamp = timestamp
                self.base = base
    
            } else {
                rates = []
                timestamp = 0
                base = ""
            }
        }
    
    var conversionRates: [Rate] {
        return rates.allObjects as? [Rate] ?? []
    }

}
