//
//  CurrencyConverterViewModel.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import UIKit

protocol CurrencyConverterVMProtocol {
    typealias DataSource = [Currency]
    var feeCalculator: FeeCalculatorProtocol { get set }
    var currencyManager: CurrencyManagerProtocol { get set }
    
    func loadDataSource()
    func convertValue(from: Currency, to: Currency)
    func calculate(from: Currency, to type: Currency.CurrencyType)
    
    init(feeCalculator: FeeCalculatorProtocol, currencyManager: CurrencyManagerProtocol)
    
    // callbacks
    var calculatedReceivedSumm: ((_ sum: Double) -> Void)? { get set }
    var shouldDisplayError: ((_ error: String) -> Void)? { get set }
    var displaySuccessConvertation: ((_ title: String, _ message: String) -> Void)? { get set }
    var dataSourceUpdated: ((DataSource) -> Void)? { get set }
}

class CurrencyConverterViewModel: CurrencyConverterVMProtocol {
    var feeCalculator: FeeCalculatorProtocol
    var currencyManager: CurrencyManagerProtocol
    
    var calculatedReceivedSumm: ((Double) -> Void)?
    var shouldDisplayError: ((String) -> Void)?
    var displaySuccessConvertation: ((String, String) -> Void)?
    var dataSourceUpdated: (([Currency]) -> Void)?
    
    required init(feeCalculator: FeeCalculatorProtocol = DefaultFeeManager(), currencyManager: CurrencyManagerProtocol = CurrencyManager()) {
        self.feeCalculator = feeCalculator
        self.currencyManager = currencyManager
    }
    
    func loadDataSource() {
        dataSourceUpdated?(currencyManager.getValues())
    }
    
    func convertValue(from: Currency, to: Currency) {
        let fee = feeCalculator.calculateFee(from: from, to: to)
        do {
            try currencyManager.convert(from: from, to: to, fee: fee)
            dataSourceUpdated?(currencyManager.getValues())
            let title = "Currency converted"
            let message = "You have converted \(from.displayText) to \(to.displayText). Commision Fee - \(fee.displayText)"
            self.displaySuccessConvertation?(title, message)
        } catch {
            self.shouldDisplayError?(error.localizedDescription)
        }
    }
    
    func calculate(from: Currency, to type: Currency.CurrencyType) {
        ExchangeAPI.request(.exchange(from: from.type, value: from.value, to: type), codable: ExhangeApiResponseDTO.self) { [weak self] response in
            self?.calculatedReceivedSumm?(response.amount)
        } failure: { [weak self] error in
            self?.shouldDisplayError?(error.localizedDescription)
        }
    }
}
