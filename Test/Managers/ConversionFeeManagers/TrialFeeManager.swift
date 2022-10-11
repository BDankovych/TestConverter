//
//  TrialFeeManager.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

class TrialFeeManager: FeeCalculatorProtocol {
    private var freeConversionCount: Int
    private var feePercentage: Double

    init(freeTimes: Int = 5, feePercentage: Double = 1) {
        self.freeConversionCount = freeTimes
        self.feePercentage = feePercentage
    }
    
    private enum Keys: String {
        case conversionCount
        
        var key: String {
            String(describing: Self.self) + " " + rawValue
        }
    }
    
    func calculateFee(from: Currency, to: Currency) -> Currency {
        var currentCount: Int = KeyChainManager.load(key: Keys.conversionCount.rawValue)?.intValue ?? 0
        
        defer {
            currentCount += 1
            KeyChainManager.save(key: Keys.conversionCount.rawValue, data: currentCount.data)
        }
        
        if currentCount < freeConversionCount {
            return Currency(type: from.type, value: 0)
        } else {
            return Currency(type: from.type, value: from.value * (feePercentage / 100))
        }
    }
}
