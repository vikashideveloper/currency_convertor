//
//  CurrencyConvertorViewModel.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import Foundation
import SwiftUI

@MainActor
final class CurrencyConvertorViewModel: ObservableObject {
    private let dataService: DataService!
    private let currencyConvertor: CurrencyConvertorHelper!
    private let defaultBase = "USD"
    
    init(service: DataService, convertor: CurrencyConvertorHelper) {
        dataService = service
        currencyConvertor = convertor
    }
    
    var baseRates = [Rate]() {
        didSet {
            currencyConvertor.baseRates = baseRates
        }
    }
    
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
    
    @Published var rates = [Rate]() //converted rates, will be assigned once conversion is finished by convertor.
    @Published var error: Error?
    @Published var loadingState = LoadingState.none
    
    private func clearError() {
        error = nil
    }
    
    private func clearRates() {
        rates = []
    }
}

// connection to repository
extension CurrencyConvertorViewModel {
    func fetchCurrencyConvertorData() async {
        dataService.updateStatusIfNeedToFetchFromRemote()
        await fetchCurrencies()
        await fetchRates()
        dataService.updateLastStorageTimeIfNeeded()
    }
    
    private func fetchCurrencies() async {
        clearError()
        loadingState = .loadingCurrencies
        let result =  await dataService.fetchCurrencies()
        loadingState = .finished
        
        switch result {
        case .success(let currencies):
            self.currencies = currencies.sorted(by: {$0.name < $1.name})
            // make selected default base currency.
            if let defulatCurrency = currencies.first(where: {$0.code == defaultBase}) {
                selectedCurrency = defulatCurrency
            }
        case .failure(let error):
            self.error = error
            self.currencies = []
        }
    }
    
    private func fetchRates() async {
        loadingState = .loadingRates
        let result = await dataService.fetchRates(base: defaultBase)
        loadingState = .finished
        
        switch result {
        case .failure(let error):
            self.error = error
            baseRates = []
        case .success(let response):
            // save base rates in convertor object, so it can perform the conversion based on these.
            let rates = response.conversionRates.sorted(by: {$0.code < $1.code})
            baseRates = rates
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

extension CurrencyConvertorViewModel {
    static func instantiateWithDI() -> CurrencyConvertorViewModel {
        let appId = Utility.infoForKey("OE_APP_ID")
        let repository = OpenExchangeRepository(appId: appId)
        let storage = CoreDataStorage()
        let dataService = DataService(repository: repository, store: storage)
        
        let convertor = CurrencyConvertorHelper()
        let viewModel = CurrencyConvertorViewModel(service: dataService, convertor: convertor)
        return viewModel
    }
}

extension CurrencyConvertorViewModel {
    enum LoadingState {
        case loadingCurrencies
        case loadingRates
        case finished
        case none
    }
}
