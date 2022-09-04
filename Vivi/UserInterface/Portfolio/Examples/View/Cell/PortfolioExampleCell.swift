//
//  PortfolioExampleCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class PortfolioExampleCell: ReusableCell {
    var example: ProjectExample?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.launchScreen()
        return imageView
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
    }
    
    func setupConstraints() {
        imageView.easy.layout(Edges())
    }

    func configure(viewModel: ProjectExample) {
        self.example = viewModel
        guard let url = URL(string: viewModel.titleImageUrl ?? "") else { return }
        imageView.sd_setImage(with: url)
    }
}
