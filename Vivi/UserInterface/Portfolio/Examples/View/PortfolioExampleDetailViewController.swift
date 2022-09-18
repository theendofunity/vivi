//
//  PortfolioExampleDetailViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 18.09.2022.
//

import UIKit
import EasyPeasy

class PortfolioExampleDetailViewController: UIViewController {
    var presenter: PortfolioExampleDetailPresenter!
    var dataSource: UICollectionViewDiffableDataSource<NewExampleSection, URL>?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .big)
        return label
    }()
    
    private lazy var descriptionLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .normal)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(cell: PhotoGalleryCell.self)
        collectionView.register(header: TitleHeader.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupDataSource()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        navigationBarWithLogo()

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        let width = UIScreen.main.bounds.width
        
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Width(width),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        containerView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        titleLabel.easy.layout(
            Top(16),
            Leading(24)
        )
        
        descriptionLabel.easy.layout(
            Top(16).to(titleLabel),
            Leading(24),
            Trailing(24)
        )
        
        collectionView.easy.layout(
            Top(24).to(descriptionLabel),
            Leading(24),
            Trailing(24),
            Width(width - 48),
            Bottom()
        )
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<NewExampleSection, URL>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCell.reuseId, for: indexPath) as? PhotoGalleryCell else { return UICollectionViewCell() }
            
            cell.configure(with: itemIdentifier)
            return cell
        })
        dataSource?.supplementaryViewProvider = { collectionView, string, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeader.reuseId, for: indexPath) as? TitleHeader else { return UICollectionReusableView() }
            if let section = NewExampleSection(rawValue: indexPath.section) {
                header.configure(title: section.title)
            }
            return header
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.createSection()
        }
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        header.pinToVisibleBounds = true
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [header]
        
        layout.configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}

extension PortfolioExampleDetailViewController: PortfolioExampleDetailViewType {
    func setTitles(title: String?, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    func update(example: ProjectExample) {
        var snapshot = NSDiffableDataSourceSnapshot<NewExampleSection, URL>()
        snapshot.appendSections(NewExampleSection.allCases)
        snapshot.appendItems(example.drafts.urls.compactMap{URL(string: $0)}, toSection: .drafts)
        snapshot.appendItems(example.visualisations.urls.compactMap{URL(string: $0)}, toSection: .visualisations)
        snapshot.appendItems(example.result.urls.compactMap{URL(string: $0)}, toSection: .result)
        
        dataSource?.apply(snapshot)
        
        collectionView.easy.layout(Height(CGFloat(snapshot.numberOfItems) * 220.0))
    }
    
    
}
