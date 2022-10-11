//
//  FakeLaunchView.swift
//  Test
//
//  Created by bdankovych on 08.10.2022.
//

import UIKit

class FakeLaunchView: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let coordinator = CurrencyConverterViewCoordinator(presenter: self, forcePresent: false)
        coordinator.start(embedInNav: true)
    }
}
