//
//  TappableLabel.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 29.04.2023.
//

import UIKit

class TappableLabel: UILabel {
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}

