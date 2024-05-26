//
//  DetailViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func configureVC()
    func configureImage()
    func configureLabels()
    func configureScrollView()
    func configureContentView()
    func configureFavButton()
}

final class DetailViewController: UIViewController {
    
    private let gameDetail: GameDetail
    
    private let viewModel = DetailViewModel()
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var customImage: CustomImageView!
    private var customFavButton: UIButton!
    private var gameTitleLabel: UILabel!
    private var gameDateLabel: UILabel!
    private var gameRatingLabel: UILabel!
    private var gameDescriptionLabel: UILabel!
    
    init(gameDetail: GameDetail) {
        self.gameDetail = gameDetail
        super.init(nibName: nil, bundle: nil)
        viewModel.configure(with: gameDetail)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

}

extension DetailViewController: DetailViewControllerProtocol {
     
    func configureVC() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .clear
        view.backgroundColor = UIColor(hex: "#1C212C")
    }
    
    func configureImage() {
        customImage = CustomImageView(frame: .zero)
        customImage.loadImage(gameUrl: gameDetail.backgroundImage)
        contentView.addSubview(customImage)
        
        customImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            customImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customImage.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    func configureFavButton() {
        customFavButton = UIButton()
        customFavButton.setImage(UIImage(named: "heart"), for: .normal)
        customFavButton.setImage(UIImage(named: "heart.fill"), for: .selected)
        customFavButton.isUserInteractionEnabled = true
        customFavButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        contentView.addSubview(customFavButton)
        customFavButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customFavButton.bottomAnchor.constraint(equalTo: customImage.bottomAnchor, constant: -8),
            customFavButton.trailingAnchor.constraint(equalTo: customImage.trailingAnchor, constant: -16),
            customFavButton.widthAnchor.constraint(equalToConstant: 50),
            customFavButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        contentView.bringSubviewToFront(customFavButton)
    }
    
    @objc private func favButtonTapped() {
        customFavButton.isSelected.toggle()
        if customFavButton.isSelected {
            viewModel.saveGameToFavorites()
        } else {
            viewModel.removeGameFromFavorites()
        }
        print("Favorite button tapped")
    }
    
    func updateFavButtonState(isFavorite: Bool) {
        customFavButton.isSelected = isFavorite
    }
    
    func configureLabels() {
        gameTitleLabel = UILabel()
        gameDateLabel = UILabel()
        gameRatingLabel = UILabel()
        gameDescriptionLabel = UILabel()
        
        gameTitleLabel.configure(color: .white, fontSize: 22, fontWeight: .semibold, textAlignment: .left, text: gameDetail.name)
        gameDateLabel.configure(color: .gray, fontSize: 14, fontWeight: .light, textAlignment: .left, text: gameDetail.released)
        gameRatingLabel.configure(color: .gray, fontSize: 14, fontWeight: .light, textAlignment: .left, text: "Metacritic Score: " + String(gameDetail.metacritic ?? 0))
        gameDescriptionLabel.configure(color: .white, fontSize: 17, fontWeight: .medium, textAlignment: .natural ,lineNumber: 0, text: gameDetail.descriptionRaw)
        
        
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gameDateLabel.translatesAutoresizingMaskIntoConstraints = false
        gameRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        gameDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(gameTitleLabel)
        contentView.addSubview(gameDateLabel)
        contentView.addSubview(gameRatingLabel)
        contentView.addSubview(gameDescriptionLabel)
        
        
        NSLayoutConstraint.activate([
            gameTitleLabel.topAnchor.constraint(equalTo: customImage.bottomAnchor, constant: 8),
            gameTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        
            gameDateLabel.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 8),
            gameDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        
            gameRatingLabel.topAnchor.constraint(equalTo: gameDateLabel.bottomAnchor, constant: 8),
            gameRatingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        
            gameDescriptionLabel.topAnchor.constraint(equalTo: gameRatingLabel.bottomAnchor, constant: 8),
            gameDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gameDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gameDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        
        contentView.layoutIfNeeded()
        updateScrollViewContentSize()
    }
    
    private func updateScrollViewContentSize() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.height)
    }
    
    func configureScrollView() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    func configureContentView() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    
        ])
    }
}
