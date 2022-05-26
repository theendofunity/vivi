//
//  PhotoGalleryViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 23.05.2022.
//

import UIKit
import EasyPeasy

enum GallerySection {
    case photo
}

class PhotoGalleryViewController: UIViewController {
    
    
    var presenter: PhotoGalleryPresenter!
    var dataSource: UICollectionViewDiffableDataSource<GallerySection, URL>?
    
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
        collection.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 50, right: 0)
        collection.delegate = self
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
            Leading(16),
            Trailing(16),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        mainButton.easy.layout(
            Bottom(24).to(view.safeAreaLayoutGuide, .bottom),
            Leading(24),
            Trailing(24)
        )
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitem: item,
                                                       count: 3)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
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
    
    @objc func buttonPressed() {
        presenter.mainButtonPressed()
    }
}

extension PhotoGalleryViewController: PhotoGalleryViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
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
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        
        navigationController?.present(picker, animated: true)
    }
    
    func update(urls: [URL]) {
        var snapshot = NSDiffableDataSourceSnapshot<GallerySection, URL>()
        snapshot.appendSections([.photo])
        snapshot.appendItems(urls, toSection: .photo)
        dataSource?.apply(snapshot)
    }
}

extension PhotoGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[.imageURL] as? URL else { return }
        presenter.uploadPhoto(url: url)
        dismiss(animated: true)
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.photoDidSelect(indexPath: indexPath)
    }
}
