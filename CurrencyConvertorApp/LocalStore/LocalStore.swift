//
//  LocalStore.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 06/04/24.
//

import Foundation
import CoreData

protocol LocalStore {
    func saveCurrencies(_ currencies: [Currency])
    func saveRateResponse(_ response: RateResponse)
    func fetchCurrencies() -> [Currency]?
    func fetchRateResponse() -> RateResponse?
    func removeAllCurrencies()
    func removeAllRateResponse()
    func createEntity<T: NSManagedObject>()-> T
}

extension LocalStore {
    static var offlineDataStorageTimeKey: String { "OfflineDataStorageTimeKey" }
    
    func updateLastStorageTime(_ time: Date = .now) {
        UserDefaults.standard.setValue(time, forKey: Self.offlineDataStorageTimeKey)
    }
    
    // check if time is more than 30 minutes since last update
    func lastStorageTimeExceeded() -> Bool {
        if let lastStorageDate = UserDefaults.standard.value(forKey: Self.offlineDataStorageTimeKey) as? Date {
            let seconds = Date.now.seconds(from: lastStorageDate)
            return TimeInterval(seconds) >= 30*60
        }
        return true
    }
}

