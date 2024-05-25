//
//  UIStackView+Ext.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 23.05.2024.
//

import UIKit

extension UIStackView {
    func configure(axis: NSLayoutConstraint.Axis, spacing: CGFloat, views: [UIView], distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
