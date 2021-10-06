//
//  UIActivityIndicatorView.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//

import UIKit

extension UIActivityIndicatorView {
    
    static func activityView () -> UIActivityIndicatorView {
        
        var activityView = UIActivityIndicatorView()
        activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .gray
        activityView.backgroundColor = .black
        activityView.startAnimating()
        activityView.alpha = 0.3
        return activityView
    }
    
}
