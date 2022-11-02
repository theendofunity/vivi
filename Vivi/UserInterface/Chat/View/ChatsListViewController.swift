//
//  ChatViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class ChatsListViewController: UIViewController {
    enum Section {
        case chats
    }
    
    var presenter: ChatsListPresenter!
    var dataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
    weak var navigationDelegate: TabConfiguratorDelegate?
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addButtonPressed))
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: ChatCell.self)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupNavigationBar()
        setupSearch()
        configureDataSource()
        
        presenter.viewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewAppeared()
    }
    
    func setupView() {
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
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = button
        navigationBarWithLogo()
    }
    
    @objc func addButtonPressed() {
        presenter.addButtonPressed()
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
        dataSource = UICollectionViewDiffableDataSource<Section, ChatModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.reuseId, for: indexPath) as? ChatCell else { return UICollectionViewCell() }
            cell.configure(chat: itemIdentifier)
            return cell
        })
    }
    
    func reload(chats: [ChatModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
        snapshot.appendSections([.chats])
        snapshot.appendItems(chats, toSection: .chats)
        dataSource?.apply(snapshot)
        collectionView.reloadData()
    }
}

extension ChatsListViewController: ChatViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func update(chats: [ChatModel]) {
        reload(chats: chats)
    }
    
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func hideAddButton(isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .clear

        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .denim
        }
        navigationBarWithLogo()
    }
}

extension ChatsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChatCell,
        let chat = cell.chat else { return }
        
        presenter.chatDidSelected(chat: chat)
    }
}

extension ChatsListViewController: UISearchBarDelegate {
    
}
