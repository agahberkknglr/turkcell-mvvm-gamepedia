//
//  FavoriteViewModel.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import Foundation
import CoreData

protocol FavoriteViewModelProtocol {
    var view: FavoriteViewControllerProtocol? {get set}
    
    func load()
    func viewWillAppear()
    func viewDidLoad()
    func numberOfItems() -> Int
    func cellforItem(at index: IndexPath) -> GameDetail
    func getDetail(id: Int)
    func emptyViewVisibility()
}

final class FavoriteViewModel {
    weak var view: FavoriteViewControllerProtocol?
    
    private let service = GameService()
    private var favoriteGames: [GameDetail] = []
    
    private func fetchFavoriteGames() {
        favoriteGames = CoreDataManager.shared.fetchFavoriteGames()
        view?.reloadCollectionView()
    }
}

extension FavoriteViewModel: FavoriteViewModelProtocol{
    
    func load() {
        fetchFavoriteGames()
        emptyViewVisibility()
    }
    func viewWillAppear() {
        fetchFavoriteGames()
        emptyViewVisibility()
        view?.configUI()
    }
    
    func viewDidLoad() {
        view?.configTitle()
        view?.configCollectionView()
        view?.reloadCollectionView()
        emptyViewVisibility()
    }
    
    func numberOfItems() -> Int {
        favoriteGames.count
    }
    
    func cellforItem(at index: IndexPath) -> GameDetail {
        favoriteGames[index.item]
    }
    
    func getDetail(id: Int) {
        service.downloadGameDetail(id: id) { [weak self] returnedGame in
            guard let self = self else { return }
            guard let returnedGame = returnedGame else { return }
            self.view?.navigateToDetailScreen(gameDetail: returnedGame)
        }
    }
    
    func emptyViewVisibility() {
        let isEmpty = favoriteGames.isEmpty
        if isEmpty {
            view?.showEmptyView()
        } else {
            view?.hideEmptyView()
        }
    }
}
