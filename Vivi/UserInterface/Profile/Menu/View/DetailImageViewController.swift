//
//  DetailImageViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 26.05.2022.
//

import UIKit
import EasyPeasy

class DetailImageViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<GallerySection, URL>?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.template()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
       
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .denim
//        collection.isPagingEnabled = true
        collection.register(cell: PhotoGalleryCell.self)
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        configureDataSource()
    }
    

    func setupView() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
    }
    
    func setupConstraints() {
        closeButton.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            Trailing(24),
            Width(25),
            Height(25)
        )
        
        collectionView.easy.layout(
            Edges()
        )
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<GallerySection, URL>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCell.reuseId, for: indexPath) as? PhotoGalleryCell else { return UICollectionViewCell() }
            cell.configure(with: itemIdentifier)
            return cell
        })
    }
    
    func update(urls: [URL], selectedIndex: IndexPath) {
        var snapshot = NSDiffableDataSourceSnapshot<GallerySection, URL>()
        snapshot.appendSections([.photo])
        snapshot.appendItems(urls, toSection: .photo)
        dataSource?.apply(snapshot)
        self.collectionView.scrollToItem(at: selectedIndex, at: .centeredVertically, animated: false)
        print(#function, selectedIndex)
        
        
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
}
