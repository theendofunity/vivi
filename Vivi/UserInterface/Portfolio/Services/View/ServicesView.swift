//
//  ServicesView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

protocol ServiceViewDelegate: AnyObject {
    func serviceDidSelect(service: ServiceType)
}

class ServicesView: UIView {
    weak var delegate: ServiceViewDelegate?
    
    private var services: [ServiceType] = []
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Услуги"
        label.textColor = .denim
        label.font = .titleFont
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: ServiceCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(title)
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        title.easy.layout(
            Top(),
            CenterX()
        )
        
        collectionView.easy.layout(
            Top(24).to(title, .bottom),
            Leading(),
            Trailing(),
            Bottom()
        )
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configure(services: [ServiceType]) {
        self.services = services
    }
}

extension ServicesView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCell.reuseId, for: indexPath) as? ServiceCell else { return UICollectionViewCell() }
        cell.configure(service: services[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ServiceCell,
        let service = cell.service else { return }
        delegate?.serviceDidSelect(service: service)
    }
}
