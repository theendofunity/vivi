//
//  PhotoGalleryViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 23.05.2022.
//

import UIKit
import EasyPeasy

class PhotoGalleryViewController: UIViewController {
    enum Section {
        case photo
    }
    
    var presenter: PhotoGalleryPresenter!
    var dataSource: UICollectionViewDiffableDataSource<Section, URL>?
    private lazy var mainButton: MainButton = {
        let button = MainButton()
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
       
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(cell: PhotoGalleryCell.self)
//        collection.delegate = self
//        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 50, right: 0)
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarBase()
        
        setupView()
        setupConstraints()
        configureDataSource()
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
    
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 16
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitem: item,
                                                     count: 3)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, URL>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCell.reuseId, for: indexPath) as? PhotoGalleryCell else { return UICollectionViewCell() }
            cell.configure(with: itemIdentifier)
            return cell
        })
    }
    
    @objc func buttonPressed() {
        presenter.mainButtonPressed()
    }
}

extension PhotoGalleryViewController: PhotoGalleryViewType {
    func setupTitle(title: String) {
        navigationItem.title = title
    }
    
    func setupButton(title: String, isHidden: Bool) {
        mainButton.setTitle(title, for: .normal)
        mainButton.isHidden = isHidden
    }
    
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func selectPhoto() {
        
    }
    
    func update(urls: [URL]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, URL>()
        snapshot.appendSections([.photo])
        snapshot.appendItems(urls, toSection: .photo)
        dataSource?.apply(snapshot)
    }
}
