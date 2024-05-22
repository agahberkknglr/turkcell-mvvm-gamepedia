//
//  HomeViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 20.05.2024.
//

import UIKit

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        let pageViewController = CustomPageViewController()
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            pageViewController.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
    }
    
}




