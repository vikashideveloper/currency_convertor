//
//  LocalStore.swift
//  Pay2dc_Assignment_vikash_Kumar
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
    func updateLastStorageTime() {
        UserDefaults.standard.setValue(Date(), forKey: "LastStorageTime")
    }
    
    // check if time is more than [30 minutes] since last update
    func checkIfNeedToFetchFromRemote() -> Bool {
        if let lastStorageDate = UserDefaults.standard.value(forKey: "LastStorageTime") as? Date {
            let seconds = Date.now.seconds(from: lastStorageDate)
            return seconds >= 2*60
        }
        return true
    }
}

