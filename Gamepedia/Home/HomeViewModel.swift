//
//  HomeViewModel.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 22.05.2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var view: HomeViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func numberOfItemsInSection() -> Int
    func cellforItem(at indexPath: IndexPath) -> Game

}

final class HomeViewModel {
    weak var view: HomeViewControllerProtocol?
    
    private var games = [Game]()
    private var pageViewGames = [Game]()
    private let service = GameService()
    
    private func fetchGame() {
        service.downloadGames { [weak self] result in
            guard let self = self else { return }
            guard let result = result else { return }
            self.games = result
            self.pageViewGames = Array(result.prefix(3))
            self.updatePageViewControllerImages()
            self.view?.reloadCollectionView()
        }
    }
    
    private func updatePageViewControllerImages() {
        let imageUrls = pageViewGames.compactMap { $0.backgroundImage }
        view?.loadImages(from: imageUrls)
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func viewDidLoad() {
        view?.setupPageViewController()
        view?.setupCollectionView()
        fetchGame()
    }
    
    func viewWillAppear() {
        
    }
    
    func numberOfItemsInSection() -> Int {
        return max(0, games.count - 3)
    }
    
    func cellforItem(at indexPath: IndexPath) -> Game {
        let adjustedIndex = indexPath.item + 3
        guard adjustedIndex < games.count else {
            fatalError("Index out of range")
        }
        return games[adjustedIndex]
    }
    
    
}
