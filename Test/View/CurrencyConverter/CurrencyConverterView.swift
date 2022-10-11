//
//  CurrencyConverterView.swift
//  Test
//
//  Created by bdankovych on 08.10.2022.
//

import UIKit

class CurrencyConverterView: UIViewController {
    @IBOutlet private weak var walletView: WalletView!
    @IBOutlet private weak var sellExhangeView: ExchangeView!
    @IBOutlet private weak var receiveExhangeView: ExchangeView!
    @IBOutlet private weak var submitButton: UIButton!
    
    private var dataSource = CurrencyConverterVMProtocol.DataSource()
    var viewModel: CurrencyConverterVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        setupNavigationBar()
        setupGestures()
    }
    
    private func setupView() {
        walletView.dataSource = self
        setupExhangeViews()
        setupSumbitButton()
    }
    
    private func setupSumbitButton() {
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
    }
    
    private func setupExhangeViews() {
        sellExhangeView.currencyType = .EUR
        sellExhangeView.type = .sell
        sellExhangeView.delegate = self
        receiveExhangeView.currencyType = .USD
        receiveExhangeView.type = .receive
        receiveExhangeView.delegate = self
    }
    
    private func setupGestures() {
        let dismisKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismisKeyboardGesture)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.standardAppearance.backgroundColor = .systemBlue
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
    
    private func setupViewModel() {
        viewModel.shouldDisplayError = { self.displayError($0) }
        viewModel.displaySuccessConvertation = { self.displaySuccessConvertation($0, $1) }
        
        viewModel.dataSourceUpdated = { dataSource in
            self.dataSource = dataSource
            self.walletView.reloadData()
        }
        
        viewModel.calculatedReceivedSumm = { self.receiveExhangeView.setValue($0) }
        
        viewModel.loadDataSource()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func submitPressed() {
        let from = Currency(type: sellExhangeView.currencyType, value: sellExhangeView.value)
        let to = Currency(type: receiveExhangeView.currencyType, value: receiveExhangeView.value)
        
        viewModel.convertValue(from: from, to: to)
    }
    
    private func displayError(_ message: String) {
        presentAlert(title: "Error", message: message)
    }
    
    private func displaySuccessConvertation(_ title: String, _ message: String) {
        let btnTitle = "Done"
        presentAlert(title: title, message: message, btnTitle: btnTitle)
    }
}

extension CurrencyConverterView: ExchangeViewDelegate {
    func currencyChanged(view: ExchangeView, currency: Currency.CurrencyType) {
        calculate()
    }
    
    func changeCurrencyPressed(view: ExchangeView) {
        view.showDefaultSelector(presenter: self)
    }
    
    func valueChanged(view: ExchangeView, value: Double) {
        calculate()
    }
    
    func calculate() {
        guard !sellExhangeView.isEmpty else { return }
        
        let fromType = sellExhangeView.currencyType
        let value = sellExhangeView.value
        let to = receiveExhangeView.currencyType
        
        viewModel.calculate(from: Currency(type: fromType, value: value), to: to)
    }
    
    func shouldReturn() -> Bool {
        true
    }
}

// MARK: - WalletViewDataSource
extension CurrencyConverterView: WalletViewDataSource {
    var countOfCurrencies: Int {
        dataSource.count
    }
    
    func valueFor(item: Int) -> Currency {
        dataSource[item]
    }
}
