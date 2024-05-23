//
//  HomeViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 20.05.2024.
//

import UIKit
import SDWebImage

protocol HomeViewControllerProtocol: AnyObject {
    func setupTitle()
    func setupPageViewController()
    func setupCollectionView()
    func reloadCollectionView()
    func loadImages(from urls: [String])
    func hidePageViewController()
    func showPageViewController()
    
}

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private var collectionView: UICollectionView!
    private var pageViewController: CustomPageViewController!
    
    private var logoImageView: UIImageView!
    private var searchButton: UIButton!
    private var searchBar: UISearchBar!
    private var stackView: UIStackView!
    
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
    
    func setupTitle() {
        logoImageView = UIImageView(image: UIImage(named: "gamepedia-logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.isHidden = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = UIColor(hex: "#1C212C")
        searchBar.tintColor = .white

        
        stackView = UIStackView(arrangedSubviews: [logoImageView, searchButton, searchBar])
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapSearchButton() {
        logoImageView.isHidden = !logoImageView.isHidden
        searchBar.isHidden = !searchBar.isHidden
        searchButton.isHidden = !searchButton.isHidden
        if !searchBar.isHidden {
            searchBar.becomeFirstResponder()
            searchBar.showsCancelButton = true
        } else {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            viewModel.searchGames(with: "")
        }
    }
    
    func setupPageViewController() {
        pageViewController = CustomPageViewController()
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
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
    
    func hidePageViewController() {
        pageViewController.view.isHidden = true
    }
    
    func showPageViewController() {
        pageViewController.view.isHidden = false
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

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 || searchText.isEmpty {
            viewModel.searchGames(with: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        logoImageView.isHidden = false
        searchButton.isHidden = false
        searchBar.isHidden = true
        viewModel.searchGames(with: "")
    }
}




