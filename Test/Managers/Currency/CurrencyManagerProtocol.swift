//
//  CurrencyManagerProtocol.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

protocol CurrencyManagerProtocol {
    func getValues() -> [Currency]
    func convert(from: Currency, to: Currency, fee: Currency) throws
}
