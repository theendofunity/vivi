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
        label.numberOfLines = 0
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
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        imageView.easy.layout(
            Top(8),
            Leading(),
            Trailing(),
            Height(200)
        )
        
        titleLabel.easy.layout(
            Top(16).to(imageView),
            Leading()
        )
        
        descriptionLabel.easy.layout(
            Top(8).to(titleLabel),
            Leading(),
            Trailing(),
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
