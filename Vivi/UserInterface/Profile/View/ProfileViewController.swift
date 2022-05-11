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
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.consultation()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var userNameLabel: PlainLabel = {
        let label = PlainLabel(text: "user user", fontType: .normal)
        return label
    }()
    
    private lazy var addressLabel: PlainLabel = {
        let label = PlainLabel(text: "address address", fontType: .small)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width - 48
        layout.itemSize = CGSize(width: width, height: cellHeight)
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: ProfileMenuCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
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
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.round(55)
        avatarImageView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        containerView.easy.layout(
            Edges(),
            Width().like(scrollView, .width),
            Height(200).like(scrollView, .height)
        )
        
        avatarImageView.easy.layout(
            Top(16),
            CenterX(),
            Width(110),
            Height(110)
        )
        
        userNameLabel.easy.layout(
            Top(16).to(avatarImageView, .bottom),
            CenterX()
        )
        
        addressLabel.easy.layout(
            Top(16).to(userNameLabel, .bottom),
            CenterX()
        )
        
        collectionView.easy.layout(
            Top(50).to(addressLabel, .bottom),
            Leading(24),
            Trailing(24),
            Bottom()
        )
    }
    
    @objc func logoutPressed() {
        presenter.logout()
    }
}

extension ProfileViewController: ProfileViewType {
    func updateUserInfo(userName: String, address: String, avatar: URL?) {
        userNameLabel.text = userName
        addressLabel.text = address
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
