//
//  ViewController.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class MainViewController: UIPageViewController {
    
    let comicBookDocument = ComicBookDocument()
    var comicBookViewControllers: [ComicBookPageController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setupViewControllers()
        setupPageViewController()
        setupNavBar()
        self.delegate = self
    }
    
    // MARK: - Setup Methods
    
    func setupViewControllers() {
        comicBookViewControllers = (0...comicBookDocument.numberOfPages).map { numberOfPage in
            return ComicBookPageController()
        }
    }
    
    func setupPageViewController() {
        if let firstViewController = comicBookViewControllers?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            
            comicBookDocument.imageAtPage(index: 0) { image in
                guard let image = image else { return }
                firstViewController.populateWithImage(width: image)
            }
        }
    }
    
    func setupNavBar() {
        title = comicBookDocument.title
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = infoButton
    }
    
}

// MARK: - PageViewConroller DataSource Methods

extension MainViewController: UIPageViewControllerDataSource {
    
    // View Controller for previous page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController as! ComicBookPageController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, comicBookViewControllers.count > previousIndex else { return nil }
        let previousViewController = comicBookViewControllers[previousIndex]
        
        comicBookDocument.imageAtPage(index: previousIndex) { image in
            if let image = image {
                previousViewController.populateWithImage(width: image)
            }
        }
        
        return previousViewController
    }
    
    // View Controller for next page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController as! ComicBookPageController) else { return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard comicBookViewControllers.count != nextIndex, comicBookViewControllers.count > nextIndex else { return nil }
        let nextViewController = comicBookViewControllers[nextIndex]
        
        comicBookDocument.imageAtPage(index: nextIndex) { image in
            if let image = image {
                nextViewController.populateWithImage(width: image)
            }
        }
        return nextViewController
    }

}



// MARK: - PageViewController Delegate Methods

extension MainViewController: UIPageViewControllerDelegate {
    
    // deallocate images from previous pages
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let previousViewController = previousViewControllers.last {
            deallocateCurrentImage(at: previousViewController)
        }
    }
}


// MARK: - Controller Extensions

extension MainViewController {
    
    func deallocateCurrentImage(at viewController: UIViewController) {
        DispatchQueue.main.async {
            let currentViewController = viewController as! ComicBookPageController
            currentViewController.comicImageView.image = nil
        }

    }
}
