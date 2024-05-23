//
//  UILabel+Ext.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 23.05.2024.
//

import UIKit

extension UILabel {
    func configure(color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment, text: String? = "") {
        self.numberOfLines = 1
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textAlignment = textAlignment
        self.text = text
    }
}
