//
//  CurrencyConvertorRepository.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import Foundation



class OpenExchangeRepository: Repository {
    let appId: String
    init(appId: String) {
        self.appId = appId
    }
    
    func fetchCurrencies() async -> Result<[String: String], Error> {
        //fetch data from remote
        guard var url = URL(string: API.currencies.endPoint) else { return .failure(ConvertorError.badUrl)}
        url.append(queryItems: [URLQueryItem(name: "app_id", value: appId)])
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String] {
                return .success(json)
            }
            return .failure(ConvertorError.unexpected)

        } catch {
            return .failure(ConvertorError.handleError(error as NSError))
        }
    }

    func fetchRates(base: String) async -> Result<[String: Any], any Error> {
        guard var url = URL(string: API.latest.endPoint) else { return .failure(ConvertorError.badUrl)}
        url.append(queryItems: [URLQueryItem(name: "app_id", value: appId), URLQueryItem(name: "base", value: base)])
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                if let _ = json["error"] {
                    return .failure(ConvertorError.handleError(from: json))
                } else {
                    if let _ = json["rates"] as? [String : Any] {
                        return .success(json)
                    }
                }
            }
            return .failure(ConvertorError.unexpected)
            
        } catch {
            return .failure(ConvertorError.handleError(error as NSError))
        }
        
    }
}

extension OpenExchangeRepository {
    private enum API {
        private var domain: String { CurrencyRateSource.openExchange.domain}
        
        case latest, currencies
        
        var endPoint: String {
            switch self {
            case .latest:
                return domain + "latest.json"
            case .currencies:
                return domain + "currencies.json"
            }
        }
    }
}


// CurrencySource
enum CurrencyRateSource {
    case openExchange
    
    var domain: String {
        switch self {
        case .openExchange:
            return "https://openexchangerates.org/api/"
        }
    }
}
