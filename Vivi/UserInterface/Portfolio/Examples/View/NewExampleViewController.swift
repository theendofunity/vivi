//
//  NewExampleViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import UIKit
import EasyPeasy

enum NewExampleSection: Int, CaseIterable {
    case drafts = 0
    case visualisations
    case result
}

class NewExampleViewController: UIViewController {
    var presenter: NewExamplePresenter!
    var example : ProjectExample?
    
    var dataSource: UICollectionViewDiffableDataSource<NewExampleSection, UIImage>?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var titleTextField: TextFieldWithLabel = {
        let model = TextFieldViewModel(type: .title, value: "")
        let textField = TextFieldWithLabel(model: model)
        return textField
    }()
    
    private lazy var descriptionTextField: TextFieldWithLabel = {
        let model = TextFieldViewModel(type: .description, value: "")
        let textField = TextFieldWithLabel(model: model)
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(cell: NewExampleCell.self)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        configureDataSource()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        setupNavigationBar()
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(descriptionTextField)
        scrollView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        let width = UIScreen.main.bounds.width
        scrollView.easy.layout(Edges(), Width(width))
        
        titleTextField.easy.layout(
            Top(24),
            Leading(24),
            Trailing(24)
        )
        
        descriptionTextField.easy.layout(
            Top(24).to(titleTextField),
            Leading(24),
            Trailing(24)
        )
        
        collectionView.easy.layout(
            Top(24).to(descriptionTextField),
            Leading(24),
            Trailing(24),
            Width(width - 48),
            Height(1000)
        )
    }
    
    func setupNavigationBar() {
        navigationBarWithLogo()
        
        let button = UIBarButtonItem(title: "Cохранить",
                                     style: .done,
                                     target: self,
                                     action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = button
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
//            guard let section = NewExampleSection(rawValue: sectionIndex) else { return nil }
            
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<NewExampleSection, UIImage>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewExampleCell.reuseId, for: indexPath) as? NewExampleCell else { return UICollectionViewCell() }
            
            cell.configure(image: itemIdentifier)
            return cell
        })
    }
}

extension NewExampleViewController: NewExampleViewType {
    @objc func saveButtonPressed() {
        
    }
    
    func update(model: ProjectExample) {
        self.example = model
        
        var snapshot = NSDiffableDataSourceSnapshot<NewExampleSection, UIImage>()
        snapshot.appendSections(NewExampleSection.allCases)
        
        if var drafts: [UIImage] = model.drafts?.images {
            drafts.append(UIImage())
            snapshot.appendItems(drafts, toSection: .drafts)
        } else {
            snapshot.appendItems([UIImage(systemName: "plus")!], toSection: .drafts)
        }
        
        if var visualisations: [UIImage] = model.visualisations?.images {
            visualisations.append(UIImage())
            snapshot.appendItems(visualisations, toSection: .visualisations)
        } else {
            snapshot.appendItems([UIImage(systemName: "plus.square")!], toSection: .visualisations)
        }

        if var result: [UIImage] = model.result?.images {
            result.append(UIImage())
            snapshot.appendItems(result, toSection: .result)
        } else {
            snapshot.appendItems([UIImage(systemName: "plus")!], toSection: .result)
        }
        
        dataSource?.apply(snapshot)
    }
}
