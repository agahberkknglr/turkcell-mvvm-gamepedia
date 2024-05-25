//
//  TabbarViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import UIKit

final class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstView = UINavigationController(rootViewController: HomeViewController())
        let secondView = UINavigationController(rootViewController: FavoriteViewController())
        
        firstView.tabBarItem.image = UIImage(systemName: "gamecontroller")
        secondView.tabBarItem.image = UIImage(systemName: "heart")
        
        firstView.title = "Games"
        secondView.title = "Favorites"
        
        tabBar.tintColor = .white
        setViewControllers([firstView,secondView], animated: true)
    }
}
