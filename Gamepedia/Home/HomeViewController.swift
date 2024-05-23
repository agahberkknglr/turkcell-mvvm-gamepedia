//
//  HomeViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 20.05.2024.
//

import UIKit

protocol HomeViewControllerProtocol {
    func setupPageViewController()
    func setupCollectionView()
    func reloadCollectionView()
    
}

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private var collectionView: UICollectionView!
    var pageViewController: CustomPageViewController!
    var games = [Game]()
    let service = GameService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1C212C")
        initializePageViewController()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGame()
    }
    
    func fetchGame() {
        service.downloadCoins { [weak self] result in
            guard let self = self else { return }
            guard let result = result else { return }
            self.games = result
            print(result)
            print("getgames")
            reloadCollectionView()
        }
    }
    
    private func initializePageViewController() {
        pageViewController = CustomPageViewController()
        setupPageViewController()
    }
    
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            pageViewController.view.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: createFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hex: "#1C212C")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addConstraints(top: pageViewController.view.bottomAnchor , topConstant: 16, leading: view.leadingAnchor, bottom: view.bottomAnchor,trailing: view.trailingAnchor)
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat.deviceWidth - 32
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth + 32) / 5)
        layout.minimumInteritemSpacing = 8
        return layout
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier, for: indexPath) as! GameCell
        cell.setCell(model: games[indexPath.item])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}




