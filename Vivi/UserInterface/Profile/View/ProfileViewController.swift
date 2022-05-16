//
//  ProfileViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!
    private var menuItems: [ProfileMenuType] = []
    
    private let cellHeight: CGFloat = 60
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width - 48
        layout.itemSize = CGSize(width: width, height: cellHeight)
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: width, height: 250)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: ProfileMenuCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(title: "Выйти",
                                           style: .plain,
                                           target: self,
                                           action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = logoutButton
        navigationBarWithLogo()
        navigationItem.titleView?.easy.layout(CenterX())

    }
    
    private func setupView() {
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func setupConstraints() {
        collectionView.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            Leading(24),
            Trailing(24),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
    }
    
    @objc func logoutPressed() {
        presenter.logout()
    }
}

extension ProfileViewController: ProfileViewType {
    func updateUserInfo(userName: String, address: String, avatar: URL?) {
//        userNameLabel.text = userName
//        addressLabel.text = address
    }
    
    func updateMenu(menuItems: [ProfileMenuType]) {
        self.menuItems = menuItems
        collectionView.reloadData()
    }
    
    func navigation() -> UINavigationController? {
        return navigationController
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
