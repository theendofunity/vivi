//
//  TextMenuViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import UIKit
import EasyPeasy

class TextMenuViewController: UIViewController {
    var presenter: TextMenuPresenter!
    
    private lazy var mainButton: MainButton = {
        let button = MainButton()
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width - 48
        layout.itemSize = CGSize(width: width, height: 60)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(cell: TextMenuCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 50, right: 0)
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarBase()
        
        setupView()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
        view.addSubview(mainButton)
    }
    
    func setupConstraints() {
        collectionView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(24),
            Trailing(24),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        mainButton.easy.layout(
            Bottom(24).to(view.safeAreaLayoutGuide, .bottom),
            Leading(24),
            Trailing(24)
        )
    }
    
    @objc func buttonPressed() {
        presenter.buttonPressed()
    }
}

extension TextMenuViewController: TextMenuViewType {
    func setupTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setupButton(title: String, isHidden: Bool) {
        mainButton.setTitle(title, for: .normal)
        mainButton.isHidden = isHidden
    }
}

extension TextMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextMenuCell.reuseId, for: indexPath) as? TextMenuCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
