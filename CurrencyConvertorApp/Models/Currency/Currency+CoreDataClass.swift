//
//  Currency+CoreDataClass.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 07/04/24.
//
//

import Foundation
import CoreData

@objc(Currency)
public class Currency: NSManagedObject {

}

extension Currency {
    func set(code: String, name: String) {
        self.code = code
        self.name = name
    }
}


protocol CurrencyProtocol {
    var code: String { get set }
}
