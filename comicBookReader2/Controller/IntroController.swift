//
//  IntroViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class IntroController: UIViewController {
    
    // MARK: - UI Elements

    private let stackView: UIStackView = {
        let st = UIStackView()
        st.distribution = .fillEqually
        st.axis = .vertical
        st.translatesAutoresizingMaskIntoConstraints = false
        st.isLayoutMarginsRelativeArrangement = true
        st.spacing = 30
        return st
    }()
    
    private let cbzButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CBZ Archive", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(cbzButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private let cbrButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CBR Archive", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(cbrButtonClicked), for: .touchUpInside)
        return btn
    }()

    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constrainViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(cbzButton)
        stackView.addArrangedSubview(cbrButton)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            cbzButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            cbzButton.heightAnchor.constraint(equalToConstant: 50),
            
            cbrButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            cbrButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    // MARK: - Method Extensions
    
    @objc func cbzButtonClicked() {
        let archiveName = "The Amazing Spider-Man - The Great Newspaper Strip 01 (1980) (webrip by Lusiphur-DCP).cbz"
        guard let comic = ComicBookDocument(archiveName: archiveName) else { return }
        if comic.state == .ready {
            presentComicBookViewer(for: comic)
        }
        else {
            // throw error
            fatalError("document state is not ready")
        }
    }
    
    @objc func cbrButtonClicked() {
        let archiveName = "Winter Soldier - Second Chances (2019) (Digital) (Zone-Empire).cbr"
        
        guard let comic = ComicBookDocument(archiveName: archiveName) else { return }
        if comic.state == .ready {
            presentComicBookViewer(for: comic)
        }
        else {
            // throw error
            fatalError("document state is not ready")
        }
    }
    
    private func presentComicBookViewer(for comic: ComicBookDocument) {
        let comicBookViewer = ContainerController(comic: comic)
        navigationController?.pushViewController(comicBookViewer, animated: true)
    }
}

