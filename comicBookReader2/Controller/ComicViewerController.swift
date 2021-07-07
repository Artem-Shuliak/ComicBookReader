//
//  ViewController.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

protocol ComicViewerControllerDelegate: AnyObject {
    func getIndex(index: Int)
}

class ComicViewerController: UIPageViewController {
        
    // MARK: - Private Properties
    
    private var comicBookDocument: ComicBookDocument
    private var comicPageControllers: [ComicPageController]?
    
    // MARK: - Public Properties
    weak var ComicViewerControllerDelegate: ComicViewerControllerDelegate?
    
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
    
    private func setupViewControllers() {
        self.comicPageControllers = comicBookDocument.pages?.map{ page in
            return ComicPageController(with: page)
        }
    }
    
    func setupPageViewController() {
        dataSource = self
        
        if let firstViewController = comicPageControllers?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
}
    
    // MARK: - PageViewConroller DataSource Methods
    
    extension ComicViewerController: UIPageViewControllerDataSource {
        
        // View Controller for previous page
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let comicBookViewControllers = comicPageControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController as! ComicPageController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            guard previousIndex >= 0, comicBookViewControllers.count > previousIndex else { return nil }
            let previousViewController = comicBookViewControllers[previousIndex]
            
            self.ComicViewerControllerDelegate?.getIndex(index: previousIndex)
            
            return previousViewController
        }
        
        // View Controller for next page
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let comicBookViewControllers = comicPageControllers, let viewControllerIndex = comicBookViewControllers.firstIndex(of: viewController as! ComicPageController) else { return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            guard comicBookViewControllers.count != nextIndex, comicBookViewControllers.count > nextIndex else { return nil }
            let nextViewController = comicBookViewControllers[nextIndex]
            
            self.ComicViewerControllerDelegate?.getIndex(index: nextIndex)
            
            return nextViewController
        }
        
    }
    
    // MARK: - Controller Extensions
    
    extension ComicViewerController {
        
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
