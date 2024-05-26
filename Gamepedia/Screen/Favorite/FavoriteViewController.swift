//
//  FavoriteViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import UIKit

protocol FavoriteViewControllerProtocol: AnyObject {
    
}

final class FavoriteViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
    }

}

extension FavoriteViewController: FavoriteViewControllerProtocol {
    
}
