//
//  ConvertorError.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 06/04/24.
//

import Foundation

enum ConvertorError: Error {
    case badUrl
    case noInternet
    case serverError(String)
    case unexpected
    
    static func handleError(from json: [String : Any]) -> ConvertorError {
        if let _ = json["status"] as? Int,
           let message = json["description"] as? String {
            return .serverError(message)
        }
        return .unexpected
    }
    
    static func handleError(_ error: NSError) -> ConvertorError {
        switch error.code {
        case -1009:
            return .noInternet
        default:
            return .serverError(error.description)
        }
    }

}


extension ConvertorError {
    public var description: String {
        switch self {
        case .badUrl:
            return "The specified url is not valid."
        case .noInternet:
            return "The Internet connection appears to be offline."
        case .unexpected:
            return "An unexpected error occurred"
        case .serverError(let message):
            return message
        }
    }
}
