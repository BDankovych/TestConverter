//
//  MainStoryboard.swift
//  Test
//
//  Created by bdankovych on 08.10.2022.
//

import Foundation

struct MainStoryboard: StoryboardInstantiable {
    
    static var storyboard: Storyboard {
        .main
    }
    
    static func converterViewController(viewModel: CurrencyConverterVMProtocol) -> CurrencyConverterView {
        let vc: CurrencyConverterView = instantiateVC(type: CurrencyConverterView.self)
        vc.viewModel = viewModel
        return vc
    }
}
