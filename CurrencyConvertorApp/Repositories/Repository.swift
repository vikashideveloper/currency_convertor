//
//  Repository.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import Foundation

protocol Repository {
    func fetchCurrencies() async -> Result<[String: String], Error>
    func fetchRates(base: String) async -> Result<[String: Any], Error>
}
