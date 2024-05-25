//
//  DetailViewModel.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 25.05.2024.
//

import Foundation

protocol DetailViewModelProtocol {
    var view: DetailViewControllerProtocol? {get set}
    
    func viewDidLoad()
    func viewWillAppear()
}

final class DetailViewModel {
    weak var view: DetailViewControllerProtocol?
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
        //view?.configStack()
    }
}
