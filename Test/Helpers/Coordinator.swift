//
//  Coordinator.swift
//  Test
//
//  Created by bdankovych on 08.10.2022.
//

import UIKit

protocol ViewCoordinator {
    associatedtype ViewType: UIViewController
    
    var presenter: UIViewController { get set }
    var forcePresent: Bool { get set }
    
    init(presenter: UIViewController, forcePresent: Bool)
    
    func start(embedInNav: Bool)
    func generateView() -> ViewType
}

extension ViewCoordinator {
    func start(embedInNav: Bool) {
        var vc: UIViewController = generateView()
        
        if embedInNav {
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            vc = navVC
        }
        
        if let navigationVC = presenter.navigationController, !forcePresent {
            navigationVC.pushViewController(vc, animated: true)
        } else {
            presenter.present(vc, animated: true)
        }
    }
}
