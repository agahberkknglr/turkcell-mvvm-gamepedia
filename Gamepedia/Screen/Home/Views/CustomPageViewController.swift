//
//  CustomPageViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 22.05.2024.
//

import UIKit

protocol CustomPageViewControllerDelegate: AnyObject {
    func didTapImage(game: Game)
}

class CustomPageViewController: UIPageViewController {
    
    //MARK: - Initialize
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Variables
    weak var customDelegate: CustomPageViewControllerDelegate?
    var games = [Game]() {
        didSet {
            DispatchQueue.main.async {
                if let initialViewController = self.viewControllerAtIndex(0) {
                    self.setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
                }
            }
        }
    }
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = games.count
        pageControl.currentPage = 0
        return pageControl
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let initialViewController = viewControllerAtIndex(0) {
            setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Logic
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < games.count else {
            return nil
        }
        let game = games[index]
        let imageViewController = CustomPageDetailViewController()
        imageViewController.gameUrl = games[index].backgroundImage
        imageViewController.id = games[index].id
        imageViewController.game = games[index]
        imageViewController.delegate = self
        return imageViewController
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        _ = sender.currentPage
        if let currentViewController = viewControllers?.first as? CustomPageDetailViewController {
            if let currentIndex = games.firstIndex(where: { $0.id == currentViewController.id }) {
                let newIndex = sender.currentPage

                let direction: UIPageViewController.NavigationDirection = newIndex > currentIndex ? .forward : .reverse
                setViewControllers([viewControllerAtIndex(newIndex)!], direction: direction, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - UiPageViewControllerExtensions
extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? CustomPageDetailViewController,
              let currentIndex = games.firstIndex(where: { $0.id == imageViewController.id }),
              currentIndex > 0 else {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? CustomPageDetailViewController,
              let currentIndex = games.firstIndex(where: { $0.id == imageViewController.id }),
              currentIndex < games.count - 1 else  {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex + 1)
    }
    
}

extension CustomPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first as? CustomPageDetailViewController,
           let currentIndex = games.firstIndex(where: { $0.id == currentViewController.id }) {
            pageControl.currentPage = currentIndex
        }
    }
}

//MARK: - Delegation
extension CustomPageViewController: CustomPageDetailViewControllerDelegate {
    func didTapImage(game: Game) {
        customDelegate?.didTapImage(game: game)
    }
}



