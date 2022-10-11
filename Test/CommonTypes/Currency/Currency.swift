//
//  Currency.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

extension Currency {
    enum CurrencyType: String, Decodable, CaseIterable {
        case EUR
        case USD
        case JPY
        case UAH
        case noCurrency
        
        var displayName: String {
            switch self {
            case .EUR: return "EUR"
            case .USD: return "USD"
            case .JPY: return "JPY"
            case .UAH: return "UAH"
            case .noCurrency: return "error"
            }
        }
        
        static var allCases: [Currency.CurrencyType] {
            [.EUR, .USD, .JPY, .UAH]
        }
    }
}

struct Currency {
    var type: CurrencyType
    var value: Double
    
    var displayText: String {
        String(format: "%.2f %@", value, type.displayName)
    }
}

extension Currency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}

extension Currency: AdditiveArithmetic {
    static func - (lhs: Currency, rhs: Currency) -> Currency {
        lhs.type == rhs.type ? Currency(type: lhs.type, value: lhs.value - rhs.value) : .zero
    }
    
    static var zero: Currency = Currency(type: .noCurrency, value: 0)
    
    static func + (lhs: Currency, rhs: Currency) -> Currency {
        lhs.type == rhs.type ? Currency(type: lhs.type, value: lhs.value + rhs.value) : .zero
    }
}
