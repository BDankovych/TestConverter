//
//  DefaultError.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Moya

enum DefaultError: Swift.Error, CustomStringConvertible, LocalizedError {
    case apiError(message: String)
    case networkError(MoyaError)
    
    var description: String {
        switch self {
        case .apiError(let message):
            return message
        case .networkError(let error):
            return error.localizedDescription
        }
    }
    
    public var errorDescription: String? {
        description
    }
}
