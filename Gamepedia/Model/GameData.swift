//
//  GameData.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 21.05.2024.
//

import Foundation

struct GameData: Decodable {
    let results: [Game]?
}

struct Game: Decodable {
    let id: Int?
    let name, released, backgroundImage: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey  {
        case id, name, released, rating
        case backgroundImage = "background_image"
    }
}
