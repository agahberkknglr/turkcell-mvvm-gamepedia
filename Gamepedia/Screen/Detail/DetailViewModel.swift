//
//  DetailViewModel.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import Foundation
import CoreData

protocol DetailViewModelProtocol {
    var view: DetailViewControllerProtocol? {get set}
    
    func viewDidLoad()
    func viewWillAppear()
    func saveGameToFavorites()
    func removeGameFromFavorites()
    func isGameFavorite() -> Bool
}

final class DetailViewModel {
    weak var view: DetailViewControllerProtocol?
    private var gameDetail: GameDetail?
    
    func configure(with gameDetail: GameDetail) {
        self.gameDetail = gameDetail
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureScrollView()
        view?.configureContentView()
    }
    
    func viewWillAppear() {
        view?.configureImage()
        view?.configureFavButton()
        view?.configureLabels()
        
        if let view = view as? DetailViewController {
            view.updateFavButtonState(isFavorite: isGameFavorite())
        }
    }
    
    func saveGameToFavorites() {
        if let gameDetail = gameDetail {
            CoreDataManager.shared.saveGame(id: gameDetail.id ?? 0)
        }
    }
    
    func removeGameFromFavorites() {
        if let gameDetail = gameDetail {
            CoreDataManager.shared.removeGame(id: gameDetail.id ?? 0)
        }
    }
    
    func isGameFavorite() -> Bool {
        if let gameDetail = gameDetail {
            return CoreDataManager.shared.isGameFavorite(id: gameDetail.id ?? 0)
        }
        return false
    }
}
