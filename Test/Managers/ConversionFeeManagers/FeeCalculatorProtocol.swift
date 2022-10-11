//
//  FeeCalculatorProtocol.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

protocol FeeCalculatorProtocol: AnyObject {
    func calculateFee(from: Currency, to: Currency) -> Currency
}
