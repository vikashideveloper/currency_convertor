//
//  LocalStore.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation
import CoreData


class CoreDataStorage: NSObject, LocalStore {
    
    let container = NSPersistentContainer(name: "CurrencyConvertor")
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
    
    
    func saveCurrencies(_ currencies: [Currency]) {
       try? viewContext.save()
        updateLastStorageTime()
    }
    
    func saveRateResponse(_ response: RateResponse) {
       try? viewContext.save()
        updateLastStorageTime()
    }
    
    func fetchCurrencies() -> [Currency]? {
        if checkIfNeedToFetchLatest() {
            wipeData()
            return nil
        }
        let request = Currency.fetchRequest()
        let result = try? viewContext.fetch(request)
        return result
    }
    
    func fetchRateResponse() -> RateResponse? {
        if checkIfNeedToFetchLatest() {
            //remove from local
            wipeData()
            return nil
        }
        let request = RateResponse.fetchRequest()
        let result = try? viewContext.fetch(request)


        return result?.first
    }
    
    
    private func wipeData() {
        removeResponseFromLocal()
        removeCurrenciesFromLocal()
    }
    
    private func removeResponseFromLocal() {
        let request = RateResponse.fetchRequest()
        if let result = try? viewContext.fetch(request),
            let first = result.first {
             viewContext.delete(first)
        }
    }
    
    private func removeCurrenciesFromLocal() {
        let request = Currency.fetchRequest()
        if let result = try? viewContext.fetch(request) {
            for item in result {
               viewContext.delete(item)
            }
        }
    }
}

// model intializer to create CoreData entity object
extension CoreDataStorage {
    func create<T: NSManagedObject>()-> T {
        return T(context: viewContext)
    }
}

