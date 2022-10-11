//
//  WalletView.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import UIKit

protocol WalletViewDataSource: AnyObject {
    var countOfCurrencies: Int { get }
    func valueFor(item: Int) -> Currency
}

class WalletView: NibView {
    
    weak var dataSource: WalletViewDataSource! {
        didSet {
            reloadData()
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionLayout: UICollectionViewFlowLayout!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.minimumLineSpacing = 10
        collectionView.register(cellType: WalletViewCell.self)
        collectionView.dataSource = self
    }
    
    // MARK: - public
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WalletView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.countOfCurrencies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currency = dataSource.valueFor(item: indexPath.item)
        let cell = collectionView.cell(cellType: WalletViewCell.self, for: indexPath)
        cell.configure(currency: currency)
        return cell
    }
}
