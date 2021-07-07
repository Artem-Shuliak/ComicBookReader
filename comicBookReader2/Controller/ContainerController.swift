//
//  ContainerViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class ContainerController: UIViewController {

    // MARK: - Properties
    
    // Document
    private var document: ComicBookDocument
    
    // Views/Controllers
    private var comicViewerController: ComicViewerController
    private let bottomNavView = BottomNavView()
    
    // determines if navigation is hidden when user taps on screen
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
        self.comicViewerController = ComicViewerController(comicBookDocument: comic)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        
        comicViewerController.view.translatesAutoresizingMaskIntoConstraints = false
        comicViewerController.comicViewerControllerDelegate = self
        
        // add comicPageViewController as subview
        view.addSubview(comicViewerController.view)
        self.addChild(comicViewerController)
        comicViewerController.didMove(toParent: self)
        
        
        // add bottomNavView as subview
        view.addSubview(bottomNavView)
        bottomNavView.BottomNavViewDelegate = self
        bottomNavView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func constrainViews() {
        
        // constrain ComicPageViewController
        NSLayoutConstraint.activate([
            comicViewerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            comicViewerController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            comicViewerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            comicViewerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
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
        comicViewerController.view.addGestureRecognizer(tapGestureRecognier)
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
        comicViewerController.moveToNextPage()
    }
    
    // Delegates comicPageViewController to move to previous page
    func backwardButtonTapped() {
        comicViewerController.moveToPreviousPage()
    }
    
    
}


