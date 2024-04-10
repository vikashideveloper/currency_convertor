//
//  CurrencyConvertorRepository.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import Foundation

final class OpenExchangeRepository: Repository {
    private let appId: String
    
    init(appId: String) {
        self.appId = appId
    }
    
    func fetchCurrencies() async -> Result<[String: String], Error> {
        //fetch data from remote
        guard var url = URL(string: API.currencies.endPoint) else { return .failure(ConvertorError.badUrl)}
        url.append(queryItems: [URLQueryItem(name: "app_id", value: appId)])
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
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
    
    func fetchRates(base: String) async -> Result<[String: Any], Error> {
        guard var url = URL(string: API.latest.endPoint) else { return .failure(ConvertorError.badUrl)}
        url.append(queryItems: [URLQueryItem(name: "app_id", value: appId), URLQueryItem(name: "base", value: base)])
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
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
        private var domain: String { Utility.infoForKey("OE_BASE_URL")}
        
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

