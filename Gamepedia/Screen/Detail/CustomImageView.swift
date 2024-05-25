//
//  CustomImageView.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import UIKit
import SDWebImage


class CustomImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(gameUrl: String?) {
        if let gameUrl = gameUrl, let url = URL(string: gameUrl) {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        }
    }

}
