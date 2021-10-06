//
//  UIButton.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//

import UIKit

extension UIButton {
    
    static func padraoButton(title: String, backgroundColor: UIColor) -> UIButton{
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.yellow, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = backgroundColor
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0, alpha: 0.5).cgColor
        button.clipsToBounds = true
        
        return button
    }
}
