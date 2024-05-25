//
//  GameDetail.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import Foundation

struct GameDetail: Decodable {
    let id, metacritic: Int?
    let name, descriptionRaw, released: String?
    let website, backgroundImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case metacritic
        case name
        case descriptionRaw = "description_raw"
        case released
        case website
        case backgroundImage = "background_image"
    }
    
}
