//
//  Utility.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation


struct Utility {
    static func getSymbolForCurrencyCode(code: String) -> String {
        let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currency?.identifier == code }
        return result?.currencySymbol ?? ""
    }

}

extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}

enum Constants {
    static let OE_APP_ID = "7109897501984b519abbfcbf348d6dce"
}
