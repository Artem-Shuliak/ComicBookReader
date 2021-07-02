//
//  ViewController.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class MainViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    
    var comicBookViewControllers: [UIViewController]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = self
        setupViewControllers()
        setupPageViewController()
    }
    
    func setupViewControllers() {
        comicBookViewControllers = ComicBookContentDataModel.shared.comicBookPages.map { image in
            let pageViewController = UIViewController()
            let pageImage = UIImageView()
            pageViewController.view.addSubview(pageImage)
            pageImage.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                pageImage.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
                pageImage.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
                pageImage.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
                pageImage.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor)
            ])
            
            pageImage.image = image
            pageImage.contentMode = .scaleAspectFill
            pageImage.clipsToBounds = true
            
            return pageViewController
        }
    }
    
    func setupPageViewController() {
        if let firstViewController = comicBookViewControllers?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers else { return nil }
        guard let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard comicBookViewControllers.count > previousIndex else {
            return nil
        }
        
        return comicBookViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers else { return nil }
        guard let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        
        guard comicBookViewControllers.count != nextIndex else {
            return nil
        }

        guard comicBookViewControllers.count > nextIndex else {
            return nil
        }
        
        return comicBookViewControllers[nextIndex]
    }
    
}



