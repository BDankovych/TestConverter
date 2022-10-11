//
//  WalletViewCell.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import UIKit

class WalletViewCell: UICollectionViewCell {
    
    @IBOutlet private var currencyLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currencyLabel.text = ""
    }
    
    func configure(currency: Currency) {
        currencyLabel.text = String(format: "%.2f \(currency.type.displayName)", currency.value)
    }
}
