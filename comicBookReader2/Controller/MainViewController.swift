//
//  ViewController.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class MainViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let comicBookDocument = ComicBookDocument()
    var comicBookViewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setupViewControllers()
        setupPageViewController()
        setupNavBar()
        
    }
    
    // MARK: - Setup Methods
    
    func setupViewControllers() {
        comicBookViewControllers = comicBookDocument.comicBookInfo?.pages.compactMap { page in
            guard let image = comicBookDocument.imageAtIndex(index: page.imageNumber) else { return nil }
            let pageViewController = createPage(image: image)
            return pageViewController
        }
    }
    
    func setupPageViewController() {
        if let firstViewController = comicBookViewControllers?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupNavBar() {
        title = comicBookDocument.title
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: - UiPageViewConroller Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, comicBookViewControllers.count > previousIndex else { return nil }
        return comicBookViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController) else { return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard comicBookViewControllers.count != nextIndex, comicBookViewControllers.count > nextIndex else { return nil }
        return comicBookViewControllers[nextIndex]
    }
    
}

// MARK: - ViewController Extension Functions

extension MainViewController {
    
    func createPage(image: UIImage) -> UIViewController {
        let pageViewController = UIViewController()
        let pageImage = UIImageView()
        
        pageImage.image = image
        pageImage.contentMode = .scaleAspectFill
        pageImage.clipsToBounds = true
        
        pageViewController.view.addSubview(pageImage)
        pageImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageImage.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            pageImage.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            pageImage.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            pageImage.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor)
        ])
        
        return pageViewController
    }
    
}



