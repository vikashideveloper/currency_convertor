//
//  Pay2dc_Assignment_vikash_KumarTests.swift
//  Pay2dc_Assignment_vikash_KumarTests
//
//  Created by Vikash Kumar on 05/04/24.
//

import XCTest
@testable import Pay2dc_Assignment_vikash_Kumar

final class Pay2dc_Assignment_vikash_KumarTests: XCTestCase {
    var viewModel: CurrencyConvertorViewModel!
    var mockRepository: MockRepository!
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockRepository = MockRepository()
        let service = DataService(repository: mockRepository, store: MockLocalStore())
        viewModel = CurrencyConvertorViewModel(service: service)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func test_success_currency_APICall() async {
        mockRepository.resultCurrencies = mockRepository.readCurrenciesFromFile()
        await viewModel.fetchCurrencies()
        XCTAssert(viewModel.currencies.isEmpty == false)
    }
    
    @MainActor func test_failure_currency_APICall() async {
        mockRepository.resultCurrencies = .failure(ConvertorError.unexpected)
        await viewModel.fetchCurrencies()
        XCTAssert(viewModel.currencies.isEmpty && viewModel.error != nil)
    }
    
    @MainActor func test_success_RateResponse_APICall() async {
        mockRepository.resultRateResponse = mockRepository.readRateResponseFromFile()
        await viewModel.fetchRates()
        XCTAssert(viewModel.currencyConvertor.baseRates.isEmpty == false)
    }
    
    @MainActor func test_failure_RateResponse_APICall() async {
        mockRepository.resultRateResponse = .failure(ConvertorError.unexpected)
        await viewModel.fetchRates()
        XCTAssert(viewModel.currencyConvertor.baseRates.isEmpty)
    }
    
    // Testing rate conversion by changing base
    @MainActor func test_rateConversion() async {
        mockRepository.resultRateResponse = mockRepository.readRateResponseFromFile()
        await viewModel.fetchRates()
        
        viewModel.amountToConvert = "1"
        viewModel.selectedCurrency = viewModel.dataService.localStore.create()
       
        // set the base currency INR
        viewModel.selectedCurrency?.set(code: "INR", name: "Indian Ruppes")
        viewModel.convertRates()
        let usdConversion = viewModel.rates.first(where: {$0.code == "USD"})
        let usdRate = String(format: "%.2f", usdConversion?.rate ?? 0)
        XCTAssertEqual(usdRate, "0.01")
        
        // set the base currency USD
        viewModel.selectedCurrency?.set(code: "USD", name: "United State Dollar")
        viewModel.convertRates()
        let inrConversion = viewModel.rates.first(where: {$0.code == "INR"})
        let inrRate = String(format: "%.2f", inrConversion?.rate ?? 0)
        XCTAssertEqual(inrRate, "83.30")

    }

    // Converting rates with zero amount - no conversion take place in this case.
    // Converted rates array will be empty.
    @MainActor func test_zeroAmount_rateConversion() async {
        mockRepository.resultRateResponse = mockRepository.readRateResponseFromFile()
        await viewModel.fetchRates()
        
        viewModel.amountToConvert = "0"
        viewModel.selectedCurrency = viewModel.dataService.localStore.create()
        viewModel.selectedCurrency?.set(code: "INR", name: "Indian Ruppes")
        viewModel.convertRates()
       
        XCTAssertEqual(viewModel.rates, [])
    }


    // Converting rates with Invalid base code - no conversion take place in this case.
    // Converted rates array will be empty.
    @MainActor func test_invalidCurrency_rateConversion() async {
        mockRepository.resultRateResponse = mockRepository.readRateResponseFromFile()
        await viewModel.fetchRates()
        
        viewModel.amountToConvert = "0"
        viewModel.selectedCurrency = viewModel.dataService.localStore.create()
        viewModel.selectedCurrency?.set(code: "INVALIDCODE", name: "Indian Ruppes")
        viewModel.convertRates()
       
        XCTAssertEqual(viewModel.rates, [])
    }

    
}
