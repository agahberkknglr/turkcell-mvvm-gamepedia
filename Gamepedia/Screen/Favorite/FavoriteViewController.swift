//
//  FavoriteViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import UIKit

//MARK: - Protocols
protocol FavoriteViewControllerProtocol: AnyObject {
    func configUI()
    func configTitle()
    func configCollectionView()
    func reloadCollectionView()
    func navigateToDetailScreen(gameDetail: GameDetail)
    func showEmptyView()
    func hideEmptyView()
    
}

final class FavoriteViewController: UIViewController {
    
    //MARK: - Variables
    private let viewModel = FavoriteViewModel()
    private var collectionView: UICollectionView!
    private var logoImageView: UIImageView!
    private var emptyView: UIView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        viewModel.load()
        configTitle()
        configCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

extension FavoriteViewController: FavoriteViewControllerProtocol {
    
    //MARK: - UI Setup
    func configUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(hex: "#1C212C")
    }

    func configTitle() {
        logoImageView = UIImageView(image: UIImage(named: "gamepedia-logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func configCollectionView() {
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: createFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hex: "#1C212C")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        setupEmptyView()
        
        let stackView = UIStackView(arrangedSubviews: [ collectionView, emptyView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat.deviceWidth - 32
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth + 32) / 4)
        layout.minimumInteritemSpacing = 8
        return layout
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func navigateToDetailScreen(gameDetail: GameDetail) {
        DispatchQueue.main.async {
            let detailViewController = DetailViewController(gameDetail: gameDetail)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func setupEmptyView() {
        emptyView = UIView()
        emptyView.backgroundColor = .clear
        emptyView.isHidden = true
        
        let emptyLabel = UILabel()
        emptyLabel.text = "You haven't liked any games!"
        emptyLabel.textColor = .white
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: -300),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: emptyView.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: emptyView.trailingAnchor),
        ])
    }
    
    func showEmptyView() {
        emptyView.isHidden = false
    }
    
    func hideEmptyView() {
        emptyView.isHidden = true
    }
}

//MARK: - CollectionView Extensions
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
        let favGame = viewModel.cellforItem(at: indexPath)
        cell.setCell(model: favGame)
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getDetail(id: viewModel.cellforItem(at: indexPath).id ?? 0)
    }
}
