//
//  HomeViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 20.05.2024.
//

import UIKit
import SDWebImage

protocol HomeViewControllerProtocol: AnyObject {
    func setupPageViewController()
    func setupCollectionView()
    func reloadCollectionView()
    func loadImages(from urls: [String])
    
}

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private var collectionView: UICollectionView!
    var pageViewController: CustomPageViewController!
    private lazy var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1C212C")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func setupPageViewController() {
        pageViewController = CustomPageViewController()
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
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth + 32) / 4)
        layout.minimumInteritemSpacing = 8
        return layout
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func loadImages(from urls: [String]) {
        let urlObjects = urls.compactMap { URL(string: $0) }
        
        SDWebImagePrefetcher.shared.prefetchURLs(urlObjects) { [weak self] finishedCount, skippedCount in
            guard let self = self else { return }
            var images = [UIImage]()
            for url in urlObjects {
                if let image = SDImageCache.shared.imageFromCache(forKey: url.absoluteString) {
                    images.append(image)
                }
            }
            self.pageViewController.images = images
            self.pageViewController.pageControl.numberOfPages = images.count
            if let initialViewController = self.pageViewController.viewControllerAtIndex(0) {
                self.pageViewController.setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier, for: indexPath) as! GameCell
        let game = viewModel.cellforItem(at: indexPath)
        cell.setCell(model: game)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}




