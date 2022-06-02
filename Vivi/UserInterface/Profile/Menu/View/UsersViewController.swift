//
//  UsersViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.06.2022.
//

import UIKit
import EasyPeasy

class UsersViewController: UIViewController {
    enum Section {
        case users
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, UserModel>?
    var presenter: UsersPresenter!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: UserCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Пользователи"
        navigationBarBase()
        
        setupView()
        setupConstraints()
        configureDataSource()
        presenter.viewLoaded()
    }
    
    func setupView() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(24),
            Trailing(24),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(60))
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UserModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseId, for: indexPath) as? UserCell else { return UICollectionViewCell() }
            cell.configure(user: itemIdentifier)
            return cell
        })
    }
}

extension UsersViewController: UsersViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func update(users: [UserModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserModel>()
        snapshot.appendSections([.users])
        snapshot.appendItems(users, toSection: .users)
        dataSource?.apply(snapshot)
    }
    
    
}
