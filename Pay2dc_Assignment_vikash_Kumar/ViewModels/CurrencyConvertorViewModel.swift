//
//  CurrencyConvertorViewModel.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 05/04/24.
//

import Foundation
import SwiftUI

@MainActor
class CurrencyConvertorViewModel: ObservableObject {
    let dataService: DataService!
    let currencyConvertor: CurrencyConvertor!
    
    init(service: DataService) {
        dataService = service
        currencyConvertor = CurrencyConvertor()
    }
    
    let defaultBase = "USD"

    @Published var amountToConvert: String = "" {
        didSet {
            if amount > 0 {
                convertRates()
            } else {
                rates = []
            }
        }
    }
    
    var amount: Double {
        if let value = Double(amountToConvert) {
            return value
        }
        return 0
    }
    
    @Published var selectedCurrency: Currency? {
        didSet {
            if amount > 0 {
                convertRates()
            } else {
                rates = []
            }
        }
    }
    
    @Published var currencies = [Currency]() {
        didSet {
            selectedCurrency = currencies.first
        }
    }
    
    @Published var rates = [Rate]() //converted rates will be assigned once conversion is finished by convertor.
    @Published var error: Error?
    @Published var loadingCurrencies = false
    @Published var loadingRates = false

    
    func clearError() {
        error = nil
    }
    
    func clearRates() {
        rates = []
    }
    
}

// connection to repository
extension CurrencyConvertorViewModel {
    func fetchCurrencies() async {
        clearError()
        loadingCurrencies = true
        let result =  await dataService.fetchCurrencies()
        loadingCurrencies = false

        switch result {
        case .success(let currencies):
            self.currencies = currencies.sorted(by: {$0.name < $1.name})
            // make selected default base currency.
            if let defulatCurrency = currencies.first(where: {$0.code == defaultBase}) {
                selectedCurrency = defulatCurrency
            }
        case .failure(let error):
            self.error = error

        }
    }
    
    
    func fetchRates() async {
        loadingRates = true
        let result = await dataService.fetchRates(base: defaultBase)
        loadingRates = false

        switch result {
        case .failure(let error):
            self.error = error

        case .success(let response):
            // save base rates in convertor object, so it can perform the conversion based on these.
            let rates = response.conversionRates.sorted(by: {$0.code < $1.code})
            currencyConvertor.baseRates = rates
            convertRates()
        }
    }
}


// Rate conversion
extension CurrencyConvertorViewModel {
    func convertRates() {
        if let currency = selectedCurrency, amount > 0 {
           rates = currencyConvertor.convertFor(currencyCode: currency.code)
        }
    }
}
