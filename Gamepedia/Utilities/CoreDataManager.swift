//
//  CoreDataManager.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 26.05.2024.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Gamepedia")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveGame(id: Int, name: String, imageUrl: String) {
        let favoriteGame = FavoriteGame(context: context)
        favoriteGame.id = String(id)
        favoriteGame.name = name
        favoriteGame.imageURL = imageUrl
        
        saveContext()
    }
    
    func removeGame(id: Int) {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            saveContext()
        } catch {
            print("Failed to fetch favorite games: \(error)")
        }
    }
    
    func isGameFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch favorite games: \(error)")
            return false
        }
    }
    
    func fetchFavoriteGames() -> [GameDetail] {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        
        do {
            let favoriteGames = try context.fetch(fetchRequest)
            return favoriteGames.compactMap { favoriteGame in
                if let idString = favoriteGame.id, let id = Int(idString), let name = favoriteGame.name, let imageURL = favoriteGame.imageURL {
                    return GameDetail(id: id, metacritic: nil, name: name, descriptionRaw: nil, released: nil, website: nil, backgroundImage: imageURL)
                }
                return nil
            }
        } catch {
            print("Failed to fetch favorite games: \(error)")
            return []
        }
    }
}
