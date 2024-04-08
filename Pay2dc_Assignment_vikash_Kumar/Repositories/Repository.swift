//
//  Repository.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 07/04/24.
//

import Foundation


protocol Repository {
    func fetchCurrencies() async -> Result<[String: String], Error>
    func fetchRates(base: String) async -> Result<[String: Any], Error>
}
