//
//  ContainerViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class ContainerController: UIViewController {

    // MARK: - Properties
        
    private var document: ComicBookDocument
    private var comicPageViewController: ComicViewerController?
    private let bottomNavView = BottomNavView()
    
    private var isNavHidden: Bool = false
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constrainViews()
        setupNavBar()
        setupTapGestureRecognizer()
    }
    
    init(comic: ComicBookDocument) {
        self.document = comic
        self.comicPageViewController = ComicViewerController(comicBookDocument: comic)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        
        guard let comicPageViewController = comicPageViewController else { return }
        comicPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        comicPageViewController.ComicViewerControllerDelegate = self
        
        // add comicPageViewController as subview
        view.addSubview(comicPageViewController.view)
        self.addChild(comicPageViewController)
        comicPageViewController.didMove(toParent: self)
        
        
        // add bottomNavView as subview
        view.addSubview(bottomNavView)
        bottomNavView.BottomNavViewDelegate = self
        bottomNavView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func constrainViews() {
    
        guard let comicPageViewController = comicPageViewController else { return }
        // constrain ComicPageViewController
        NSLayoutConstraint.activate([
            comicPageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            comicPageViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            comicPageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            comicPageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        // constrain bottomNavView
        NSLayoutConstraint.activate([
            bottomNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomNavView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomNavView.heightAnchor.constraint(equalToConstant: 100),
        ])

    }
    
    private func setupNavBar() {
        title = document.title
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(activateInfoController))
        navigationItem.rightBarButtonItem = infoButton
    }
        
    private func setupTapGestureRecognizer() {
        let tapGestureRecognier = UITapGestureRecognizer(target: self, action: #selector(didTapOnPage(_:)))
        guard let comicPageViewController = comicPageViewController else { return }
        comicPageViewController.view.addGestureRecognizer(tapGestureRecognier)
    }
    
}


// MARK: - Extension Methods

extension ContainerController {
    
    @objc func activateInfoController() {
        guard let data = document.infoDictionary else { return }
        let ComicBookInfoTableViewController = ComicInfoController(data: data)
        navigationController?.present(ComicBookInfoTableViewController, animated: true, completion: nil)
    }
    
    @objc func didTapOnPage(_ sender: UITapGestureRecognizer) {
        isNavHidden.toggle()
        
        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.bottomNavView.isHidden = self.isNavHidden
            self.navigationController?.navigationBar.isHidden = self.isNavHidden
        }, completion: nil)
    }
    
}


// MARK: -  Delegate Methods

// Delegate Methods from ComicPageViewController
extension ContainerController: ComicViewerControllerDelegate {
    
    // Gets Index from ComicPageViewController
    // sets CurrentPageLabel of bottomNavView from Index
    func getIndex(index: Int) {
        bottomNavView.updateCurrentPageLabel(index: index)
    }
    
}

// Delegate Methods from BottomNavView
extension ContainerController: BottomNavViewDelegate {
    
    // Delegates comicPageViewController to move to next page
    func forwardButtonTapped() {
        comicPageViewController?.moveToNextPage()
    }
    
    // Delegates comicPageViewController to move to previous page
    func backwardButtonTapped() {
        comicPageViewController?.moveToPreviousPage()
    }
    
    
}


