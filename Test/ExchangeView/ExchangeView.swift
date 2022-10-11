//
//  ExchangeView.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import UIKit

protocol ExchangeViewDelegate: AnyObject {
    func currencyChanged(view: ExchangeView, currency: Currency.CurrencyType)
    func changeCurrencyPressed(view: ExchangeView)
    func valueChanged(view: ExchangeView, value: Double)
    func shouldReturn() -> Bool
}

extension ExchangeView {
    
    enum FieldType: String {
        case sell
        case receive
        
        var imege: UIImage? {
            switch self {
            case .sell:
                return UIImage(named: "arrow_up")
            case .receive:
                return UIImage(named: "arrow_down")
            }
        }
        
        var title: String {
            rawValue.uppercased()
        }
        
        var isInputEnabled: Bool {
            switch self {
            case .sell:
                return true
            case .receive:
                return false
            }
        }
        
        var valueInputColor: UIColor {
            switch self {
            case .sell:
                return .black
            case .receive:
                return .systemGreen
            }
        }
    }
}

class ExchangeView: NibView {
    @IBOutlet private weak var exchangeTypeImageView: UIImageView!
    @IBOutlet private weak var exchangeTypeLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var currencyButton: UIButton!
    
    weak var delegate: ExchangeViewDelegate?
    
    var currencyType: Currency.CurrencyType = .EUR {
        didSet {
            updateCurrencyType()
        }
    }
    
    var isEmpty: Bool {
        valueTextField.text?.isEmpty == true
    }
    
    var value: Double {
        guard let text = valueTextField.text, let value = Double(text) else {
            fatalError("No data")
        }
        return value
    }
    
    var type: FieldType = .sell {
        didSet {
            updateFieldType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyButton.contentHorizontalAlignment = .left
        currencyButton.semanticContentAttribute = .forceRightToLeft
        currencyButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        valueTextField.keyboardType = .numberPad
        valueTextField.placeholder = "0.00"
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(valueTextFieldChanged), for: .editingChanged)

    }
    
    private func updateFieldType() {
        exchangeTypeImageView.image = type.imege
        exchangeTypeLabel.text = type.title
        valueTextField.isUserInteractionEnabled = type.isInputEnabled
        valueTextField.textColor = type.valueInputColor
    }
    
    private func updateCurrencyType() {
        currencyButton.setTitle(currencyType.displayName, for: .normal)
        delegate?.currencyChanged(view: self, currency: currencyType)
    }
    
    @objc private func valueTextFieldChanged() {
        guard let text = valueTextField.text, let value = Double(text) else { return }
        delegate?.valueChanged(view: self, value: value)
    }
    
    @IBAction private func currencyButtonPressed() {
        delegate?.changeCurrencyPressed(view: self)
    }
    
    func setValue(_ value: Double) {
        let prefix = type == .receive ? "+ " : ""
        valueTextField.text = prefix + String(value)
    }
    
    func showDefaultSelector(currenies: [Currency.CurrencyType] = Currency.CurrencyType.allCases, presenter: UIViewController) {
        let alert = UIAlertController(title: "Choose currency", message: nil, preferredStyle: .actionSheet)
        for curreny in currenies {
            let action = UIAlertAction(title: curreny.displayName, style: .default) { [weak self, curreny]_ in
                self?.currencyType = curreny
            }
            alert.addAction(action)
        }
        presenter.present(alert, animated: true)
    }
}

extension ExchangeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.shouldReturn() ?? true
    }
}
