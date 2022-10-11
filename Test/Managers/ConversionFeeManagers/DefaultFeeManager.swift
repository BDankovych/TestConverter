//
//  DefaultFeeManager.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

class DefaultFeeManager: FeeCalculatorProtocol {
    func calculateFee(from: Currency, to: Currency) -> Currency {
        Currency(type: from.type, value: 0.7)
    }
}
