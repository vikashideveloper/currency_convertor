//
//  MockLocalStore.swift
//  CurrencyConvertorAppTests
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation
import CoreData
@testable import CurrencyConvertorApp

final class MockLocalStore: LocalStore {
    private lazy var mockPersistantContainer: NSPersistentContainer = {
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
        
    func fetchCurrencies() -> [Currency]? {
        let currency1: Currency = createEntity()
        let currency2: Currency = createEntity()
        let currency3: Currency = createEntity()
        return [currency1, currency2, currency3]
    }
    
    func fetchRateResponse() -> RateResponse? {
        let response: RateResponse = createEntity()
        let rate1: Rate = createEntity()
        let rate2: Rate = createEntity()
        response.rates = [rate1, rate2]
        return response
    }
    
    func saveCurrencies(_ currencies: [Currency]) { }
    
    func saveRateResponse(_ response: RateResponse) { }

    func removeAllCurrencies() { }
    
    func removeAllRateResponse() { }
    
    func createEntity<T: NSManagedObject> ()-> T {
        return T(context: mockPersistantContainer.viewContext)
    }
    
    func removeLastStorageTime() {
        UserDefaults.standard.removeObject(forKey: Self.offlineDataStorageTimeKey)
    }
}
