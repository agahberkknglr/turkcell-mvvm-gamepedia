//
//  GameCell.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 23.05.2024.
//

import UIKit

final class GameCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GameCell"
    
    //MARK: - Variables
    private var view = UIView()
    private var cellStackView = UIStackView()
    private var nameStackView = UIStackView()
    private var dateStackView = UIStackView()
    private var gameImage = UIImageView()
    private var gameNameLabel = UILabel()
    private var gameDateLabel = UILabel()
    private var gameRatingLabel = UILabel()
    private var dataTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImage.image = nil
        cancelDownloading()
    }
    
    func setCell(model: Game){
        gameNameLabel.text = model.name
        gameDateLabel.text = model.released
        if let ratingDouble = model.rating {
            gameRatingLabel.text = String(ratingDouble)
        }
        guard let stringURL = model.backgroundImage else { return }
        downloadImage(imageURL: stringURL)
        
    }
    
    private func downloadImage(imageURL: String) {
        
        if let cachedImage = ImageCache.shared.object(forKey: imageURL as NSString) {
            self.gameImage.image = cachedImage
            return
        }
        
        guard let url = URL(string: imageURL) else { return }
        dataTask = NetworkManager.shared.download(url: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.gameImage.image = image
                        ImageCache.shared.setObject(image, forKey: imageURL as NSString)
                    }
                }
            case .failure(_):
                break
            }
        })
    }
    private func cancelDownloading() {
        dataTask?.cancel()
        dataTask = nil
    }
    
    private func setupView() {
        contentView.addSubview(view)
        view.addSubview(cellStackView)
        configureStacks()
        configureImage()
        configureLabels()
        setupConstraints()
    }
    
    private func configureStacks() {
        cellStackView.configure(axis: .horizontal, spacing: 5, views: [gameImage, nameStackView])
        nameStackView.configure(axis: .vertical, spacing: 5, views: [gameNameLabel, dateStackView])
        dateStackView.configure(axis: .horizontal, spacing: 5, views: [gameDateLabel, gameRatingLabel])
    }
    
    private func configureImage() {
        gameImage.layer.cornerRadius = 8
        gameImage.clipsToBounds = true
        
    }
    
    private func configureLabels() {
        gameNameLabel.configure(color: .white, fontSize: 20, fontWeight: .semibold, textAlignment: .left)
        gameDateLabel.configure(color: .gray, fontSize: 15, fontWeight: .light, textAlignment: .left)
        gameRatingLabel.configure(color: .gray, fontSize: 15, fontWeight: .light, textAlignment: .right)
    }
    
    private func setupConstraints() {
        view.pin(view: contentView)
        cellStackView.pin(view: view)
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameImage.widthAnchor.constraint(equalToConstant: 70),
            gameImage.heightAnchor.constraint(equalTo: gameImage.widthAnchor, multiplier: 0.5)
        ])
        nameStackView.addConstraints(top: cellStackView.topAnchor, topConstant: 16, leading: gameImage.trailingAnchor, leadingConstant: 20, bottom: cellStackView.bottomAnchor, bottomConstant: -16, trailing: cellStackView.trailingAnchor, trailingConstant: -16)
        dateStackView.addConstraints(top: gameNameLabel.bottomAnchor, topConstant: 8, leading: nameStackView.leadingAnchor, bottom: nameStackView.bottomAnchor, trailing: nameStackView.trailingAnchor)
    }
    
}
