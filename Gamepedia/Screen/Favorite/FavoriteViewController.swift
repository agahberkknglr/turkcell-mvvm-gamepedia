//
//  FavoriteViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import UIKit

protocol FavoriteViewControllerProtocol: AnyObject {
    func configTitle()
    func configCollectionView()
    func reloadCollectionView()
    func navigateToDetailScreen(gameDetail: GameDetail)
    
}

final class FavoriteViewController: UIViewController {
    
    private let viewModel = FavoriteViewModel()
    private var collectionView: UICollectionView!
    private var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        view.backgroundColor = UIColor(hex: "#1C212C")
        viewModel.viewDidLoad()
        viewModel.load()
        configTitle()
        configCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.viewWillAppear()
        
    }

}

extension FavoriteViewController: FavoriteViewControllerProtocol {
    
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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
}

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
