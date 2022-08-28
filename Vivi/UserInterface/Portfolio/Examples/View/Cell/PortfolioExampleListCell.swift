//
//  PortfolioExampleListCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class PortfolioExampleListCell: ReusableCell {
    var example: ProjectExample?
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .big)
        return label
    }()
    
    private lazy var descriptionLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .normal)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
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
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        titleLabel.easy.layout(
            Top(8),
            Leading(8)
        )
        
        imageView.easy.layout(
            Top(16).to(titleLabel),
            Leading(8),
            Trailing(8),
            Height(100)
        )
        
        descriptionLabel.easy.layout(
            Top(16).to(imageView),
            Leading(16),
            Trailing(16),
            Bottom()
        )
    }

    func configure(example: ProjectExample) {
        self.example = example
        
        titleLabel.text = example.title
        descriptionLabel.text = example.description
        
        if let urlString = example.titleImageUrl,
           let url = URL(string: urlString) {
            imageView.sd_setImage(with: url)
        }
    }
}
