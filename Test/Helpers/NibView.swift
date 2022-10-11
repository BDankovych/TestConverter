//
//  NibView.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import UIKit

class NibView: UIView {
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    func xibSetup() {
        guard let loadedView = loadViewFromNib() else { return }
        loadedView.frame = bounds
        contentView = loadedView
        addSubview(contentView)
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layoutSubviews()
    }

    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: Self.self)
        return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
    }
}
