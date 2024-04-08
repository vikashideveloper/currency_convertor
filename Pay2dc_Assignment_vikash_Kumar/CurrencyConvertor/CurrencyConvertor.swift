//
//  CurrencyConvertor.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 06/04/24.
//

import Foundation
import CoreData


class CurrencyConvertor {
    var baseRates = [Rate]()
    
    func convertFor(currencyCode: String) -> [Rate] {
        // find the rate of given currency in default base rates.
        guard let rate = baseRates.filter({$0.code == currencyCode}).first else { return []}
        
        // rate of base [usd] currency with compare to given currency
        let baseCurrencyRate = 1/rate.rate
    
        let convertedRates = baseRates.map { rate in
            let r = Rate(context: rate.managedObjectContext!)
            r.code = rate.code
            r.symbol = rate.symbol
            r.rate = rate.rate * baseCurrencyRate
            return r
        }
        return convertedRates
    }
}

