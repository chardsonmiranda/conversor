//
//  UITextField.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//

import UIKit

extension UITextField {
    
    static func padraoTextField(placeHolder: String, placeHolderColor: UIColor, backGroundColor: UIColor) -> UITextField{
        
        let textField = UITextField()
        textField.backgroundColor = backGroundColor
        textField.textColor = UIColor(white: 1.0, alpha: 1.0)
        textField.tintColor = .black

        textField.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                     attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        return textField
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
