//
//  ScrollingImagesView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class PortfolioExampleView: UIView {
    var examples: [ProjectExample] = []
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: 395)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: PortfolioExampleCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5
        return pageControl
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
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    func setupConstraints() {
        collectionView.easy.layout(Edges())
        pageControl.easy.layout(
            Bottom(32).to(collectionView, .bottom),
            CenterX()
        )
    }
    
    func configure(examples: [ProjectExample]) {
        self.examples = examples
        pageControl.numberOfPages = examples.count
        collectionView.reloadData()
    }
}

extension PortfolioExampleView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioExampleCell.reuseId, for: indexPath) as? PortfolioExampleCell else { return UICollectionViewCell() }
        
        let viewModel = examples[indexPath.item]
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    
}
