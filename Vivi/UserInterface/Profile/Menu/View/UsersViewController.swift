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
    
    var users: [UserModel] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, UserModel>?
    var presenter: UsersPresenter!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: UserCell.self)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Пользователи"
        navigationBarBase()
        
        setupView()
        setupConstraints()
        configureDataSource()
        setupSearch()
        
        presenter.viewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewAppeared()
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
    
    func setupSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
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
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func update(users: [UserModel]) {
        self.users = users
        
        reload(users: users)
    }
    
    func reload(users: [UserModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserModel>()
        snapshot.appendSections([.users])
        snapshot.appendItems(users, toSection: .users)
        dataSource?.apply(snapshot)
    }
    
    func update(searchText: String) {
        guard !searchText.isEmpty else {
            reload(users: users)
            return
        }
        
        let filtredUsers = users.filter {
            $0.usernameTitle().lowercased().contains(searchText.lowercased())
        }
        reload(users: filtredUsers)
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        update(searchText: searchText)
    }
}

extension UsersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? UserCell,
        let user = cell.user else { return }
        
        presenter.userDidSelect(user)
    }
}
