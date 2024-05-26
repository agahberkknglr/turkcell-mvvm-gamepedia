//
//  CustomPageDetailViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 22.05.2024.
//

import UIKit
import SDWebImage

protocol CustomPageDetailViewControllerDelegate: AnyObject {
    func didTapImage(game: Game)
}

final class CustomPageDetailViewController: UIViewController {
    
    //MARK: - Variables
    weak var delegate: CustomPageDetailViewControllerDelegate?
    var game: Game?
    var gameUrl: String?
    var id: Int?

    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        loadImage()
        addTapGestureToImageView()
    }
    
    //MARK: - Setup Image
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    private func loadImage() {
        if let gameUrl = gameUrl, let url = URL(string: gameUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        }
    }
    
    private func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Delegation
    @objc private func imageTapped() {
        if let game = game {
            delegate?.didTapImage(game: game)
        }
    }
}

