//
//  MockLocalStore.swift
//  Pay2dc_Assignment_vikash_KumarTests
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation
import CoreData
@testable import CurrencyConvertorApp

class MockLocalStore: LocalStore {
    lazy var mockPersistantContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "CurrencyConvertor")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                precondition( description.type == NSInMemoryStoreType )
                if let error = error {
                    fatalError("Create an in-memory coordinator failed \(error)")
                }
            }
            return container
        }()

    func saveCurrencies(_ currencies: [Currency]) {
        
    }
    
    func saveRateResponse(_ response: RateResponse) {
        
    }
        
    func fetchCurrencies() -> [Currency]? {
        return nil
    }
    
    func fetchRateResponse() -> RateResponse? {
        return nil
    }
    
    func create<T: NSManagedObject> ()-> T {
        return T(context: mockPersistantContainer.viewContext)
    }

    func removeAllCurrencies() {
        
    }
    
    func removeAllRateResponse() {
        
    }

    func updateLastStorageTime() {
        UserDefaults.standard.setValue(Date(), forKey: "LastStorageTime")
    }
    
    // check if time is more than 3 second since last update
    func checkIfNeedToFetchLatest() -> Bool {
        if let lastStorageDate = UserDefaults.standard.value(forKey: "LastStorageTime") as? Date {
            let seconds = Date.now.seconds(from: lastStorageDate)
            return seconds >= 3
        }
        return true
    }

}
