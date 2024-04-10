//
//  CurrencyConvertorHelper.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 06/04/24.
//

import Foundation
import CoreData

final class CurrencyConvertorHelper {
    var baseRates = [Rate]()
    
    func convertFor(currencyCode: String) -> [Rate] {
        // find the rate of given currency in default base rates.
        guard let rate = baseRates.filter({$0.code == currencyCode}).first else { return []}
        
        // rate of base [usd] currency with compare to given currency
        let baseCurrencyRate = 1/rate.rate
        
        let convertedRates = baseRates.map { rate in
            let rateObj = Rate(context: rate.managedObjectContext!)
            rateObj.code = rate.code
            rateObj.symbol = rate.symbol
            rateObj.rate = rate.rate * baseCurrencyRate
            return rateObj
        }
        return convertedRates
    }
}

