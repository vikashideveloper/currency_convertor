//
//  MockRepository.swift
//  CurrencyConvertorAppTests
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation
@testable import CurrencyConvertorApp

final class MockRepository: Repository {
    var resultCurrencies: Result<[String : String], Error>?
    var resultRateResponse: Result<[String : Any], Error>?
    
    func fetchCurrencies() async -> Result<[String : String], Error> {
        return resultCurrencies ?? .failure(ConvertorError.unexpected)
    }
    
    func fetchRates(base: String) async -> Result<[String : Any],  Error> {
        return resultRateResponse ?? .failure(ConvertorError.unexpected)
    }
    
    func readCurrenciesFromFile() -> Result<[String : String], Error> {
        if let url = Bundle(for: MockRepository.self).url(forResource: "CurrenciesResponse", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: String]
                return .success(json ?? [:])
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(ConvertorError.unexpected)
        }
    }
    
    func readRateResponseFromFile() -> Result<[String : Any], Error> {
        if let url = Bundle(for: MockRepository.self).url(forResource: "RateResponse", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: Any]
                return .success(json ?? [:])
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(ConvertorError.unexpected)
        }
    }
}
