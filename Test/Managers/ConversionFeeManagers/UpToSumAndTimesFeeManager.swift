//
//  UpToSumAndTimesFeeManager.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

class UpToSumAndTimesFeeManager: FeeCalculatorProtocol {
    private var period: Int
    private var freeSum: Double
    private var feePercentage: Double
    
    init(period: Int = 0, freeSum: Double = 200, feePercentage: Double = 1) {
        self.period = period
        self.freeSum = freeSum
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
        
        if (period != 0 && currentCount % period == 0) || from.value < freeSum {
            return Currency(type: from.type, value: 0)
        } else {
            return Currency(type: from.type, value: from.value * (feePercentage / 100))
        }

    }
}
