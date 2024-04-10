//
//  Utility.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation

struct Utility {
    static func getSymbolForCurrencyCode(code: String) -> String {
        let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currency?.identifier == code }
        return result?.currencySymbol ?? ""
    }
    
    static func infoForKey(_ key: String) -> String {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "") ?? ""
    }
}

extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
