//
//  ViewController.swift
//  comicBookReader2
//
//  Created by readdle on 05.07.2021.
//

import UIKit

class ComicBookPageController: UIViewController {
    
    var comicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constrainViews()
    }
    
    func setupViews() {
        view.addSubview(comicImageView)
    }
    
    func constrainViews() {
        NSLayoutConstraint.activate([
            comicImageView.topAnchor.constraint(equalTo: view.topAnchor),
            comicImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            comicImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func populateWithImage(width image: UIImage) {
        comicImageView.image = image
    }
}
