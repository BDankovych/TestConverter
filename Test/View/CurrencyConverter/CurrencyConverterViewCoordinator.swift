//
//  CurrencyConverterViewCoordinator.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import UIKit

class CurrencyConverterViewCoordinator: ViewCoordinator {
    typealias ViewType = CurrencyConverterView

    var presenter: UIViewController
    var forcePresent: Bool
    
    required init(presenter: UIViewController, forcePresent: Bool) {
        self.presenter = presenter
        self.forcePresent = forcePresent
    }
    
    func generateView() -> CurrencyConverterView {
        let viewModel = CurrencyConverterViewModel()
        return MainStoryboard.converterViewController(viewModel: viewModel)
    }
}
