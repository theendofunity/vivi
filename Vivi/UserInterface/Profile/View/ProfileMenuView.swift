//
//  ProfileViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class ProfileMenuView: UIView {
    private var menuItems: [ProfileMenuType] = []
    
    private let cellHeight: CGFloat = 60
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width - 48
        layout.itemSize = CGSize(width: width, height: cellHeight)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: ProfileMenuCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.easy.layout(
            Top(),
            Leading(24),
            Trailing(24),
            Bottom()
        )
    }
    
    func updateMenu(menuItems: [ProfileMenuType]) {
        self.menuItems = menuItems
        collectionView.reloadData()
    }
}

extension ProfileMenuView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileMenuCell.reuseId, for: indexPath) as? ProfileMenuCell
        else { return UICollectionViewCell() }
        let item = menuItems[indexPath.item]
        cell.configure(item: item)
        return cell
    }
}
