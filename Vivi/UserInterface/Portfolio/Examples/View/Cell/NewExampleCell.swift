//
//  NewExampleCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 04.09.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class NewExampleCell: ReusableCell {
    var item: ProjectExampleChapterItem?
    
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
    }
    
    func setupConstraints() {
        imageView.easy.layout(
            Edges()
        )
    }

    func configure(item: ProjectExampleChapterItem) {
        imageView.image = item.image
        self.item = item
    }
}
