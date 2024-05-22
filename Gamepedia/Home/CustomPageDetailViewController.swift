//
//  CustomPageDetailViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 22.05.2024.
//

import UIKit

final class CustomPageDetailViewController: UIViewController {
    
    var image: UIImage?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        if let image = image {
            imageView.image = image
        }
    }
}
