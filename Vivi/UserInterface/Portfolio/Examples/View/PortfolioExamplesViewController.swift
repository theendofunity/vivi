//
//  PortfolioExamplesViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 28.08.2022.
//

import UIKit
import EasyPeasy

class PortfolioExamplesViewController: UIViewController {
    var presenter: PortfolioExamplePresenter!
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    private lazy var colletionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.register(cell: PortfolioExampleListCell.self)
        
        return collection
    }()
    
    private lazy var addButton: MainButton = {
        let button = MainButton()
        button.isHidden = true
        button.setTitle("Добавить", for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        navigationBarWithLogo()
        view.backgroundColor = .background
        view.addSubview(colletionView)
        view.addSubview(addButton)
    }
    
    func setupConstraints() {
        colletionView.easy.layout(
            Top(),
            Leading(24),
            Trailing(24),
            Bottom()
        )
        
        addButton.easy.layout(
            Leading(24),
            Trailing(24),
            Bottom(24).to(view.safeAreaLayoutGuide, .bottom)
        )
    }
    
    @objc func addButtonPressed() {
        
    }
}

extension PortfolioExamplesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.examples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioExampleListCell.reuseId, for: indexPath)  as? PortfolioExampleListCell else { return UICollectionViewCell() }
        
        cell.configure(example: presenter.examples[indexPath.item])
        return cell
    }
}

extension PortfolioExamplesViewController: PortfolioExampleViewType {
    func updateView(examples: [ProjectExample]) {
        colletionView.reloadData()
    }
    
    func showAddButton() {
        addButton.isHidden = false
    }
}
