//
//  ExhangeApiResponse.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import Foundation

struct ExhangeApiResponseDTO: Decodable {
    let amount: Double
    let currency: Currency.CurrencyType
    
    enum CodingKeys: CodingKey {
        case amount
        case currency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let amountStr = try container.decode(String.self, forKey: .amount)
        
        guard let amount = Double(amountStr) else {
            throw DefaultError.apiError(message: "Wrong data")
        }
        
        self.amount = amount
        self.currency = try container.decode(Currency.CurrencyType.self, forKey: .currency)
    }
}
