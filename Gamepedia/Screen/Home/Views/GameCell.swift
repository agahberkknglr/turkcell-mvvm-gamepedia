//
//  GameCell.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 23.05.2024.
//

import UIKit
import SDWebImage

final class GameCell: UICollectionViewCell {
    
    //MARK: - Identifier
    static let reuseIdentifier = "GameCell"
    
    //MARK: - Variables
    private var view = UIView()
    private var cellStackView = UIStackView()
    private var nameStackView = UIStackView()
    private var dateStackView = UIStackView()
    private var gameImage = UIImageView()
    private var gameNameLabel = UILabel()
    private var gameDateLabel = UILabel()
    private let spininingCircleView = SpiningCircleView()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Cell
    func setCell(model: Game){
        gameNameLabel.text = model.name
        gameDateLabel.text = model.released
        if let ratingDouble = model.rating {
            spininingCircleView.ratingLabel.text = String(ratingDouble)
            let ratingNormalized = CGFloat(ratingDouble / 5.0)
            spininingCircleView.spiningCircle.strokeEnd = ratingNormalized
            spininingCircleView.spiningCircle.strokeStart = 0
            
        }
        if let gameUrl = model.backgroundImage {
            if let url = URL(string: gameUrl) {
                gameImage.sd_setImage(with: url)
            }
        }
        
    }
    
    //MARK: - Setup UI
    private func setupView() {
        contentView.addSubview(view)
        view.addSubview(cellStackView)
        configureStacks()
        configureImage()
        configureLabels()
        setupConstraints()
    }
    
    private func configureStacks() {
        cellStackView.configure(axis: .horizontal, spacing: 16, views: [gameImage, nameStackView], alignment: .center)
        nameStackView.configure(axis: .vertical, spacing: 16, views: [gameNameLabel, dateStackView], distribution: .equalSpacing)
        dateStackView.configure(axis: .horizontal, spacing: 5, views: [gameDateLabel, spininingCircleView], distribution: .fill)
    }
    
    private func configureImage() {
        gameImage.contentMode = .scaleAspectFit
        gameImage.layer.cornerRadius = 8
        gameImage.clipsToBounds = true
        
    }
    
    private func configureLabels() {
        gameNameLabel.configure(color: .white, fontSize: 17, fontWeight: .semibold, textAlignment: .left)
        gameDateLabel.configure(color: .lightGray, fontSize: 14, fontWeight: .medium, textAlignment: .left)
        spininingCircleView.ratingLabel.configure(color: .lightGray, fontSize: 14, fontWeight: .medium, textAlignment: .center)
    }
    
    private func setupConstraints() {
        view.pin(view: contentView)
        cellStackView.pin(view: view)
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        spininingCircleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameImage.widthAnchor.constraint(equalToConstant: 100),
            gameImage.heightAnchor.constraint(equalTo: gameImage.widthAnchor, multiplier: 0.5625),
            spininingCircleView.widthAnchor.constraint(equalToConstant: 40),
            spininingCircleView.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        nameStackView.addConstraints(top: cellStackView.topAnchor, topConstant: 8, leading: gameImage.trailingAnchor, leadingConstant: 20, bottom: cellStackView.bottomAnchor, bottomConstant: -16, trailing: cellStackView.trailingAnchor, trailingConstant: -16)
        dateStackView.addConstraints(top: gameNameLabel.bottomAnchor, topConstant: 8, leading: nameStackView.leadingAnchor, bottom: nameStackView.bottomAnchor, trailing: nameStackView.trailingAnchor)
    }
    
}

