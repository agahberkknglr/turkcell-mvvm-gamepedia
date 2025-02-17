//
//  APIURLs.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 21.05.2024.
//

import Foundation

struct APIURLs {
    static let apiKey: String = "54cabb85666c494787e7243c4ae0d185"
    static let baseURL: String = "https://api.rawg.io/api/games"
    static let key: String = "?key="
    
    static func gamesUrl() -> String {
        baseURL + "?key=" + apiKey
    }
    static func gamesDetailURL(id: Int) -> String {
        baseURL + "/\(id)" + key + apiKey
    }
}
