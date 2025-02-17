//
//  HomeViewModel.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 22.05.2024.
//

import Foundation

//MARK: - Protocols
protocol HomeViewModelProtocol {
    var view: HomeViewControllerProtocol? { get set }
    func viewWillAppear()
    func viewDidLoad()
    func numberOfItemsInSection() -> Int
    func cellforItem(at indexPath: IndexPath) -> Game
    func searchGames(with query: String)
    func isSearchingClosed()
    func numberOfItemsInPageView() -> Int
    func pageforItem(at index: Int) -> Game
    func getDetail(id: Int)
}

final class HomeViewModel {
    
    //MARK: - Variables
    weak var view: HomeViewControllerProtocol?
    
    private var isSearching: Bool = false
    private var allGames: [Game] = []
    private var games = [Game]()
    private var pageViewGames = [Game]()
    private let service = GameService()
    
    private func fetchGame() {
        service.downloadGames { [weak self] result in
            guard let self = self else { return }
            guard let result = result else { return }
            self.allGames = result
            self.games = result
            self.pageViewGames = Array(result.prefix(3))
            self.updatePageViewControllerImages()
            self.view?.reloadCollectionView()
        }
    }
    
    private func updatePageViewControllerImages() {
        view?.sendGames()
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    
    //MARK: - LifeCycles
    func viewDidLoad() {
        view?.setupTitle()
        view?.setupPageViewController()
        view?.setupCollectionView()
    }
    
    func viewWillAppear() {
        view?.setupVC()
        fetchGame()
    }
    
    //MARK: - Logics
    func numberOfItemsInSection() -> Int {
        if isSearching{
            return games.count
        }
        return max(0, games.count - 3)
    }
    
    func cellforItem(at indexPath: IndexPath) -> Game {
        if isSearching {
            return games[indexPath.item]
        } else {
            let adjustedIndex = indexPath.item + 3
            guard adjustedIndex < games.count else {
                fatalError("Index out of range")
            }
            return games[adjustedIndex]
        }
    }
    
    func gamesforPages() -> [Game] {
        pageViewGames
    }
    
    func numberOfItemsInPageView() -> Int {
        pageViewGames.count
    }
    
    func pageforItem(at index: Int) -> Game {
        pageViewGames[index]
    }
    
    func searchGames(with query: String) {
        isSearching = !query.isEmpty && query.count >= 3
        games = isSearching ? allGames.filter { $0.name?.lowercased().contains(query.lowercased()) ?? false } : allGames
        view?.reloadCollectionView()
        games.isEmpty ? view?.showEmptySearchView() : view?.hideEmptySearchView()
        isSearching ? view?.hidePageViewController() : view?.showPageViewController()
    }
    
    func isSearchingClosed() {
        isSearching = false
    }
    
    func getDetail(id: Int) {
        service.downloadGameDetail(id: id) { [weak self] returnedGame in
            guard let self = self else { return }
            guard let returnedGame = returnedGame else { return }
            self.view?.navigateToDetailScreen(gameDetail: returnedGame)
        }
    }
}

