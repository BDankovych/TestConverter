//
//  ExchangeAPI.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import Moya

enum ExchangeAPI {
    case exchange(from: Currency.CurrencyType, value: Double, to: Currency.CurrencyType)
}

extension ExchangeAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "http://api.evp.lt")!
    }
    
    var path: String {
        switch self {
        case .exchange(let from, let value, let to):
            let params = String(format: "%.2f-%@/%@", value, from.displayName, to.displayName)
            return "currency/commercial/exchange/\(params)/latest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .exchange:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .exchange:
            return .requestPlain
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .exchange:
            return URLEncoding.default
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .exchange:
            return nil
        }
    }
}
