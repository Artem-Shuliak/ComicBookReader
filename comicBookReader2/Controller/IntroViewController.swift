//
//  IntroViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class IntroViewController: UIViewController {

    let stackView: UIStackView = {
        let st = UIStackView()
        st.distribution = .fillEqually
        st.axis = .vertical
        st.translatesAutoresizingMaskIntoConstraints = false
        st.isLayoutMarginsRelativeArrangement = true
        st.spacing = 30
        return st
    }()
    
    let cbzButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CBZ Archive", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(cbzButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    let cbrButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CBR Archive", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(cbrButtonClicked), for: .touchUpInside)
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constrainViews()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(cbzButton)
        stackView.addArrangedSubview(cbrButton)
    }
    
    func constrainViews() {
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
    
    @objc func cbzButtonClicked() {
        let archiveName = "The Amazing Spider-Man - The Great Newspaper Strip 01 (1980) (webrip by Lusiphur-DCP).cbz"
        instantiateComicBookViewer(from: archiveName)
    }
    
    @objc func cbrButtonClicked() {
        let archiveName = "Winter Soldier - Second Chances (2019) (Digital) (Zone-Empire).cbr"
        instantiateComicBookViewer(from: archiveName)
    }
    
    func instantiateComicBookViewer(from archive: String) {
        let comicBookViewer = ContainerViewController(archiveName: archive)
        navigationController?.pushViewController(comicBookViewer, animated: true)
    }
}

