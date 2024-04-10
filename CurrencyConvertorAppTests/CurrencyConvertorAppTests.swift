//
//  CurrencyConvertorAppTests.swift
//  CurrencyConvertorAppTests
//
//  Created by Vikash Kumar on 07/04/24.
//

import XCTest
@testable import CurrencyConvertorApp

final class CurrencyConvertorAppTests: XCTestCase {
    private var viewModel: CurrencyConvertorViewModel?
    private var mockRepository: MockRepository?
    private var mockLocalStore: MockLocalStore?
    
    @MainActor override func setUpWithError() throws {
        mockRepository = MockRepository()
        mockLocalStore = MockLocalStore()
        let service = DataService(repository: mockRepository!, store: mockLocalStore!)
        let convertor = CurrencyConvertorHelper()
        viewModel = CurrencyConvertorViewModel(service: service, convertor: convertor)
    }
    
    override func tearDownWithError() throws {
        mockLocalStore?.removeLastStorageTime()
        mockRepository = nil
        mockLocalStore = nil
        viewModel = nil
    }
    
    @MainActor func test_lastStorage_time_hasFinished() async {
        let time30MinutesAgo = Date.now.addingTimeInterval(-30*60)
        mockLocalStore?.updateLastStorageTime(time30MinutesAgo)
        let result = mockLocalStore?.lastStorageTimeExceeded() // it should return true if time is exceeded 3 seconds
        XCTAssertEqual(result, true)
    }
    
    @MainActor func test_currencies_fetched_from_localStore() async {
        mockRepository?.resultCurrencies = mockRepository?.readCurrenciesFromFile()
        let timeWithin30Minutes = Date.now.addingTimeInterval(-25*60)
        mockLocalStore?.updateLastStorageTime(timeWithin30Minutes)
        
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssertEqual(viewModel?.currencies.count, 3) // only 3 items are added in mockLocalStore
    }
    
    @MainActor func test_currencies_fetched_from_remote() async {
        mockRepository?.resultCurrencies = mockRepository?.readCurrenciesFromFile()
        let time30MinutesAgo = Date.now.addingTimeInterval(-30*60)
        mockLocalStore?.updateLastStorageTime(time30MinutesAgo)
        
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssertEqual(viewModel?.currencies.count, 170) // 170 items are added in mock json
    }
    
    @MainActor func test_rates_fetched_from_localStore() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        let timeWithin30Minutes = Date.now.addingTimeInterval(-25*60)
        mockLocalStore?.updateLastStorageTime(timeWithin30Minutes)
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssertEqual(viewModel?.baseRates.count, 2) // only 2 items are added in mockLocalStore
    }
    
    @MainActor func test_rates_fetched_from_remote() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        let time30MinutesAgo = Date.now.addingTimeInterval(-30*60)
        mockLocalStore?.updateLastStorageTime(time30MinutesAgo)
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssertEqual(viewModel?.baseRates.count, 169) // 169 items are added in mock json
    }
    
    @MainActor func test_conversion_USD_to_INR() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        viewModel?.amountToConvert = "1"
        viewModel?.selectedCurrency = mockLocalStore?.createEntity()
        viewModel?.selectedCurrency?.set(code: "USD", name: "United State Dollar") // set the base currency USD
        viewModel?.convertRates()
        let inrConversion = viewModel?.rates.first(where: {$0.code == "INR"})
        let inrRate = String(format: "%.2f", inrConversion?.rate ?? 0)
        XCTAssertEqual(inrRate, "83.30")
    }
    
    @MainActor func test_conversion_INR_to_JPY() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        viewModel?.amountToConvert = "1"
        viewModel?.selectedCurrency = mockLocalStore?.createEntity()
        viewModel?.selectedCurrency?.set(code: "INR", name: "Indian Ruppes") // set the base currency INR
        viewModel?.convertRates()
        let jpyConverstion = viewModel?.rates.first(where: {$0.code == "JPY"})
        let jpyRate = String(format: "%.2f", jpyConverstion?.rate ?? 0)
        XCTAssertEqual(jpyRate, "1.82")
    }
    
    @MainActor func test_conversion_JPY_to_USD() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        viewModel?.amountToConvert = "1"
        viewModel?.selectedCurrency = mockLocalStore?.createEntity()
        viewModel?.selectedCurrency?.set(code: "JPY", name: "Japanese Yen") // set the base currency JPY
        viewModel?.convertRates()
        let usdConverstion = viewModel?.rates.first(where: {$0.code == "USD"})
        let usdRate = String(format: "%.2f", usdConverstion?.rate ?? 0)
        XCTAssertEqual(usdRate, "0.01")
    }

    // Converting rates with zero amount - no conversion take place in this case.
    // Converted rates array will be empty.
    @MainActor func test_zeroAmount_rateConversion() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        
        viewModel?.amountToConvert = "0" // set the input amount zero
        viewModel?.selectedCurrency = mockLocalStore?.createEntity()
        viewModel?.selectedCurrency?.set(code: "INR", name: "Indian Ruppes")
        viewModel?.convertRates()
        XCTAssertEqual(viewModel?.rates, [])
    }
    
    // Converting rates with Invalid base code - no conversion take place in this case.
    // Converted rates array will be empty.
    @MainActor func test_invalidCurrency_rateConversion() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        viewModel?.amountToConvert = "1"
        viewModel?.selectedCurrency = mockLocalStore?.createEntity()
        viewModel?.selectedCurrency?.set(code: "INVALIDCODE", name: "Indian Ruppes")
        viewModel?.convertRates()
        XCTAssertEqual(viewModel?.rates, [])
    }
    
    @MainActor func test_success_currency_APICall() async {
        mockRepository?.resultCurrencies = mockRepository?.readCurrenciesFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssert(viewModel?.currencies.isEmpty == false)
    }
    
    @MainActor func test_failure_currency_APICall() async {
        mockRepository?.resultCurrencies = .failure(ConvertorError.unexpected)
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssert(viewModel?.currencies.isEmpty == true && viewModel?.error != nil)
    }
    
    @MainActor func test_success_RateResponse_APICall() async {
        mockRepository?.resultRateResponse = mockRepository?.readRateResponseFromFile()
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssert(viewModel?.baseRates.isEmpty == false)
    }
    
    @MainActor func test_failure_RateResponse_APICall() async {
        mockRepository?.resultRateResponse = .failure(ConvertorError.unexpected)
        await viewModel?.fetchCurrencyConvertorData()
        XCTAssert(viewModel?.baseRates.isEmpty == true)
    }
}
