//
//  ViewController.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

protocol ComicPageViewCotrollerDelegate: AnyObject {
    func getIndex(index: Int)
}

class ComicPageViewController: UIPageViewController {
    
    
    // MARK: - Properties
    
    var comicBookDocument: ComicBookDocument
    var comicBookViewControllers: [ComicBookPageController]?
    weak var ComicPageViewCotrollerDelegate: ComicPageViewCotrollerDelegate?
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupPageViewController()
    }
    
    init(comicBookDocument: ComicBookDocument) {
        self.comicBookDocument = comicBookDocument
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Setup Methods
    
    func setupViewControllers() {
        comicBookViewControllers = (0...comicBookDocument.numberOfPages).map { numberOfPage in
            return ComicBookPageController()
        }
    }
    
    func setupPageViewController() {
        dataSource = self
        delegate = self
        
        if let firstViewController = comicBookViewControllers?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            
            comicBookDocument.imageAtPage(index: 0) { image in
                guard let image = image else { return }
                firstViewController.populateWithImage(width: image)
            }
        }
    }
}

// MARK: - PageViewConroller DataSource Methods

extension ComicPageViewController: UIPageViewControllerDataSource {
    
    // View Controller for previous page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let comicBookViewControllers = comicBookViewControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController as! ComicBookPageController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, comicBookViewControllers.count > previousIndex else { return nil }
        let previousViewController = comicBookViewControllers[previousIndex]
        
        ComicPageViewCotrollerDelegate?.getIndex(index: previousIndex)
        
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
        
        ComicPageViewCotrollerDelegate?.getIndex(index: nextIndex)
        
        comicBookDocument.imageAtPage(index: nextIndex) { image in
            if let image = image {
                nextViewController.populateWithImage(width: image)
            }
        }
        return nextViewController
    }
    
}


// MARK: - PageViewController Delegate Methods

extension ComicPageViewController: UIPageViewControllerDelegate {
    
    // deallocate images from previous pages
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let previousViewController = previousViewControllers.last {
            deallocateCurrentImage(at: previousViewController)
        }
    }
}


// MARK: - Controller Extensions

extension ComicPageViewController {
    
    // Deallocate Image from the PreviousViewController to free up memory
    func deallocateCurrentImage(at viewController: UIViewController) {
        DispatchQueue.main.async {
            let currentViewController = viewController as! ComicBookPageController
            currentViewController.comicImageView.image = nil
        }
        
    }
    
    // move PageViewController to next page
    func moveToNextPage() {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    // move PageViewController to previous page
    func moveToPreviousPage() {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let previousViewController = self.dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }
}
