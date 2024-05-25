//
//  GameService.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 21.05.2024.
//

import Foundation

class GameService {
    
    func downloadGames(completion: @escaping ([Game]?) -> ()) {
        guard let url = URL(string: APIURLs.gamesUrl()) else { return }
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(self.handelingData(data))
            case .failure(let error):
                self.handelingError(error)
            }
        }
    }
    
    func downloadGameDetail(id: Int, completion: @escaping (GameDetail?) -> () ) {
        guard let url = URL(string: APIURLs.gamesDetailURL(id: id)) else { return }
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                completion(self.handelingData(data))
            case.failure(let error):
                self.handelingError(error)
            }
        }
    }
    
    private func handelingError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    private func handelingData(_ data: Data) -> [Game]? {
        do {
            let game = try JSONDecoder().decode(GameData.self, from: data)
            return game.results 
        } catch {
            print(error)
            return nil
        }
    }
    
    private func handelingData(_ data: Data) -> GameDetail? {
        do {
            let game = try JSONDecoder().decode(GameDetail.self, from: data)
            return game
        } catch {
            print(error)
            return nil
        }
    }
}
