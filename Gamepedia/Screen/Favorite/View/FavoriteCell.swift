//
//  FavoriteCell.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 26.05.2024.
//

import UIKit
import SDWebImage

final class FavoriteCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FavoriteCell"
    
    private let view = UIView()
    private let stackView = UIStackView()
    private let gameImage = UIImageView()
    private let gameNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(model: GameDetail) {
        gameNameLabel.text = model.name
        if let gameUrl = model.backgroundImage {
            if let url = URL(string: gameUrl) {
                gameImage.sd_setImage(with: url)
            }
        }
    }
    
    private func setupView() {
        contentView.addSubview(view)
        view.addSubview(stackView)
        configStackView()
        configImageView()
        configLabel()
        setConstraints()
    }
    
    private func configStackView() {
        stackView.configure(axis: .horizontal, spacing: 32, views: [gameImage,gameNameLabel])
    }
    
    private func configImageView() {
        gameImage.contentMode = .scaleAspectFit
        gameImage.layer.cornerRadius = 8
        gameImage.clipsToBounds = true
    }
    
    private func configLabel() {
        gameNameLabel.configure(color: .white, fontSize: 17, fontWeight: .semibold, textAlignment: .left, lineNumber: 0)
    }
    
    private func setConstraints() {
        view.pin(view: contentView)
        stackView.pin(view: view)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameImage.widthAnchor.constraint(equalToConstant: 100),
            gameImage.heightAnchor.constraint(equalTo: gameImage.widthAnchor, multiplier: 0.5625),
            gameImage.topAnchor.constraint(greaterThanOrEqualTo: stackView.topAnchor , constant: 16),
            gameImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            gameImage.trailingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor, constant: -8),
            gameNameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            gameNameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
        ])
    }
}
