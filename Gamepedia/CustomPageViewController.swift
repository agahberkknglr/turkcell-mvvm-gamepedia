//
//  CustomPageViewController.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 22.05.2024.
//

import UIKit

class CustomPageViewController: UIPageViewController {
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var images: [UIImage] = [
        UIImage(named: "image1")!,
        UIImage(named: "image2")!,
        UIImage(named: "image3")!,
    ]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
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
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < images.count else {
            return nil
        }
        
        let imageViewController = CustomPageDetailViewController()
        imageViewController.image = images[index]
        return imageViewController
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        if let currentViewController = viewControllers?.first as? CustomPageDetailViewController {
            if let currentIndex = images.firstIndex(of: currentViewController.image!) {
                let newIndex = sender.currentPage

                let direction: UIPageViewController.NavigationDirection = newIndex > currentIndex ? .forward : .reverse
                setViewControllers([viewControllerAtIndex(newIndex)!], direction: direction, animated: true, completion: nil)
            }
        }
    }
}

extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? CustomPageDetailViewController,
              let image = imageViewController.image,
              let index = images.firstIndex(of: image),
              index > 0 else {
            return nil
        }
        
        return viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageViewController = viewController as? CustomPageDetailViewController,
              let image = imageViewController.image,
              let index = images.firstIndex(of: image),
              index < images.count - 1 else {
            return nil
        }
        
        return viewControllerAtIndex(index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first as? CustomPageDetailViewController,
           let index = images.firstIndex(of: currentViewController.image!) {
            pageControl.currentPage = index
        }
    }
}
