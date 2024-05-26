//
//  HomeViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 20.05.2024.
//

import UIKit
import SDWebImage

//MARK: - Protocols
protocol HomeViewControllerProtocol: AnyObject {
    func setupVC()
    func setupTitle()
    func setupPageViewController()
    func setupCollectionView()
    func reloadCollectionView()
    func sendGames()
    func hidePageViewController()
    func showPageViewController()
    func navigateToDetailScreen(gameDetail: GameDetail)
    func showEmptySearchView()
    func hideEmptySearchView()
}

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private var collectionView: UICollectionView!
    private var pageViewController: CustomPageViewController!
    private var logoImageView: UIImageView!
    private var searchButton: UIButton!
    private var searchBar: UISearchBar!
    private var titleStackView: UIStackView!
    private var emptySearchView: UIView!
    
    private lazy var viewModel = HomeViewModel()
    
    //MARK: - Lifecycles
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

extension HomeViewController: HomeViewControllerProtocol {
    
    //MARK: - UISetup
    func setupVC() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(hex: "#1C212C")
    }
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

        titleStackView = UIStackView(arrangedSubviews: [logoImageView, searchButton, searchBar])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 32
        titleStackView.alignment = .leading
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: titleStackView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: titleStackView.centerYAnchor),
            
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
        pageViewController.customDelegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 16),
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
        
        setupEmptyView()
        
        let stackView = UIStackView(arrangedSubviews: [pageViewController.view, collectionView, emptySearchView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 16),
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
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func sendGames() {
        DispatchQueue.main.async {
            self.pageViewController.games = self.viewModel.gamesforPages()
            self.pageViewController.pageControl.numberOfPages = self.viewModel.numberOfItemsInPageView()
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
    
    func navigateToDetailScreen(gameDetail: GameDetail) {
        DispatchQueue.main.async {
            let detailViewController = DetailViewController(gameDetail: gameDetail)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showEmptySearchView() {
        emptySearchView.isHidden = false
    }
    
    func hideEmptySearchView() {
        emptySearchView.isHidden = true
    }
    
    private func setupEmptyView() {
        emptySearchView = UIView()
        emptySearchView.backgroundColor = .clear
        emptySearchView.isHidden = true
        
        let emptyLabel = UILabel()
        emptyLabel.text = "Sorry, no results found!"
        emptyLabel.textColor = .white
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptySearchView.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: emptySearchView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptySearchView.topAnchor, constant: -300),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: emptySearchView.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: emptySearchView.trailingAnchor), 
        ])
    }
}

//MARK: - CollectionView Extensions
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getDetail(id: viewModel.cellforItem(at: indexPath).id ?? 0)
    }
}

//MARK: - SearchBar Extension
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
        viewModel.searchGames(with: searchBar.text ?? "")
        viewModel.isSearchingClosed()
    }
}

//MARK: - UIPageViewControllerDelegation
extension HomeViewController: CustomPageViewControllerDelegate {
    func didTapImage(game: Game) {
        viewModel.getDetail(id: game.id ?? 0)
    }
}
