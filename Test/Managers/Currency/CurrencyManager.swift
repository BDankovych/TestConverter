//
//  CurrencyManager.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import Foundation

class CurrencyManager: CurrencyManagerProtocol {
    private var currencies = [Currency.CurrencyType: Double]()
    
    private enum Keys: String {
        case isFirstLaunch
    }
    
    init() {
        for currencyType in Currency.CurrencyType.allCases {
            let value = KeyChainManager.load(key: currencyType.displayName)?.doubleValue ?? 0
            currencies[currencyType] = value
        }
        
        if KeyChainManager.load(key: Keys.isFirstLaunch.rawValue) == nil {
            setInitialValues()
        }
    }
    
    @discardableResult
    private func save() -> Bool {
        var result = true
        for var currency in currencies {
            result = KeyChainManager.save(key: currency.key.displayName, data: currency.value.data).isSuccess && result
        }
        return result
    }
    
    private func setInitialValues() {
        currencies[.EUR] = 1000
        var trueData = 1
        KeyChainManager.save(key: Keys.isFirstLaunch.rawValue, data: trueData.data)
    }
    
    func convert(from: Currency, to: Currency, fee: Currency) throws {
        guard let currentFromValue = currencies[from.type],
              let currentToValue = currencies[to.type] else {
            throw DefaultError.apiError(message: "Wrong Currency")
        }
        
        guard from.value + fee.value < currentFromValue else {
            throw DefaultError.apiError(message: "Not enough \(from.type.displayName) to convert \(from.displayText) with fee \(fee.displayText)")
        }
        
        currencies[from.type] = currentFromValue - from.value - fee.value
        currencies[to.type] = currentToValue + to.value
        
        guard save() else { throw DefaultError.apiError(message: "Something wrong") }
    }
    
    func getValues() -> [Currency] {
        currencies.map { Currency(type: $0.key, value: $0.value) }
    }
}
