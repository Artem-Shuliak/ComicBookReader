//
//  BottomNavView.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

protocol BottomNavViewDelegate: AnyObject {
    func forwardButtonTapped()
    func backwardButtonTapped()
}

class BottomNavView: UIView {
    
    weak var BottomNavViewDelegate: BottomNavViewDelegate?
    
    let stackView: UIStackView = {
        let st = UIStackView()
        st.distribution = .fillEqually
        st.axis = .horizontal
        st.translatesAutoresizingMaskIntoConstraints = false
        st.isLayoutMarginsRelativeArrangement = true
        st.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return st
    }()
    
    let backButton: UIButton = {
        let btn = UIButton()
        let btnImage = UIImage(systemName: "arrowtriangle.backward.fill")
        btn.setImage(btnImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let forwardButton: UIButton = {
        let btn = UIButton()
        let btnImage = UIImage(systemName: "arrowtriangle.forward.fill")
        btn.setImage(btnImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let currentPageLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "1"
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        constrainViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .secondarySystemBackground
        
        addSubview(stackView)
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(currentPageLabel)
        stackView.addArrangedSubview(forwardButton)
    }
    
    func constrainViews() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateCurrentPageLabel(index: Int) {
        currentPageLabel.text = "\(index)"
    }
    
    @objc func forwardButtonTapped() {
        BottomNavViewDelegate?.forwardButtonTapped()
    }
    
    @objc func backwardButtonTapped() {
        BottomNavViewDelegate?.backwardButtonTapped()
    }
    
}
