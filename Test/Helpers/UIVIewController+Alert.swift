//
//  UIVIewController+Alert.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String?, btnTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
