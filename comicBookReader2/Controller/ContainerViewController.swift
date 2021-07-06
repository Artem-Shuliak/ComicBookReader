//
//  ContainerViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: - Properties
    
    let document = ComicBookDocument()
    var comicPageViewController: ComicPageViewController?
    let bottomNavView = BottomNavView()
    
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicPageViewController = ComicPageViewController(comicBookDocument: document)
        
        setupViews()
        constrainViews()
        setupNavBar()
    }
    
    // MARK: - Setup Methods
    
    func setupViews() {
        guard let comicPageViewController = comicPageViewController else { return }
        comicPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        comicPageViewController.ComicPageViewCotrollerDelegate = self
        
        view.addSubview(comicPageViewController.view)
        self.addChild(comicPageViewController)
        comicPageViewController.didMove(toParent: self)
        
        view.addSubview(bottomNavView)
        bottomNavView.BottomNavViewDelegate = self
        bottomNavView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .secondarySystemBackground
    }
    
    func constrainViews() {
        
        guard let comicPageViewController = comicPageViewController else { return }
        // constrain ComicPageViewController
        NSLayoutConstraint.activate([
            comicPageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            comicPageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            comicPageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            comicPageViewController.view.bottomAnchor.constraint(equalTo: bottomNavView.topAnchor, constant: 0)
        ])
        
        // constrain bottomNavView
        NSLayoutConstraint.activate([
            bottomNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomNavView.topAnchor.constraint(equalTo: comicPageViewController.view.bottomAnchor, constant: 0),
            bottomNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomNavView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])

    }
    
    func setupNavBar() {
        title = document.title
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(activateInfoController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc func activateInfoController() {
        guard let data = document.infoDictionary else { return }
        let ComicBookInfoTableViewController = ComicBookInfoTableViewController(data: data)
        navigationController?.present(ComicBookInfoTableViewController, animated: true, completion: nil)
    }

}


// MARK: -  Delegate Methods

// Delegate Methods from ComicPageViewController
extension ContainerViewController: ComicPageViewCotrollerDelegate {
    
    // Gets Index from ComicPageViewController
    // sets CurrentPageLabel of bottomNavView from Index
    func getIndex(index: Int) {
        bottomNavView.updateCurrentPageLabel(index: index)
    }
    
}

// Delegate Methods from BottomNavView
extension ContainerViewController: BottomNavViewDelegate {
    
    // Delegates comicPageViewController to move to next page
    func forwardButtonTapped() {
        comicPageViewController?.moveToNextPage()
    }
    
    // Delegates comicPageViewController to move to previous page
    func backwardButtonTapped() {
        comicPageViewController?.moveToPreviousPage()
    }
    
    
}


