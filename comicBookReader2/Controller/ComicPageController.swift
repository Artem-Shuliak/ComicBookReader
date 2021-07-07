//
//  ViewController.swift
//  comicBookReader2
//
//  Created by readdle on 05.07.2021.
//

import UIKit

class ComicPageController: UIViewController {
    
    // MARK: - Properties

    private var page: ComicBookPage
    
    // MARK: - View Elements
    
    private var comicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Lifecycle Methods
    
    init(with page: ComicBookPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constrainViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.page.loadImage { image in
            DispatchQueue.main.async {
                self.comicImageView.image = image
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.page.isLoadingImage {
            print("CANCELLING IMAGE")
            self.page.cancelImageLoading()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.comicImageView.image = nil
        }
    }
    
    private func setupViews() {
        view.addSubview(comicImageView)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            comicImageView.topAnchor.constraint(equalTo: view.topAnchor),
            comicImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            comicImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Public Method
    
    func populateWithImage(width image: UIImage) {
        self.comicImageView.image = image
    }
}
