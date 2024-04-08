//
//  DataService.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 06/04/24.
//

import Foundation



class DataService {
    let repository: Repository
    let localStore: LocalStore
   
    init(repository: Repository, store: LocalStore) {
        self.repository = repository
        self.localStore = store
    }
    
    func fetchCurrencies() async -> Result<[Currency], Error> {
        // check if data avaiale in local store
        if let currencies = localStore.fetchCurrencies() {
            return .success(currencies)
        }
        
        // fetch from remote
        let result = await repository.fetchCurrencies()
        switch result {
        case .success(let response):
            let currencies = response.map { object in
                let currency: Currency = localStore.create()
                currency.set(code: object.key, name: object.value)
                return currency
            }
            
            localStore.saveCurrencies(currencies) // save currencies in local store
            return .success(currencies)
        case .failure(let error):
            return .failure(error)
        }
    }

    func fetchRates(base: String) async -> Result<RateResponse, any Error> {
        //check if data available in local store
        if let response = localStore.fetchRateResponse() {
            return .success(response)
        }
        
        //fetch data from remote
        let result = await repository.fetchRates(base: base)
        switch result {
        case .success(let response):
            let resObj: RateResponse = localStore.create()
            resObj.set(json: response)
            localStore.saveRateResponse(resObj) // save rate response in local store
            return .success(resObj)
        case .failure(let error):
            return .failure(error)
        }
    }

}
