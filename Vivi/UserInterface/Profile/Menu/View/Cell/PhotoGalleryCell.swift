//
//  PhotoGalleryCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 24.05.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class PhotoGalleryCell: ReusableCell {
    var url: URL?
    
    lazy var photoView: UIImageView = {
        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
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
        addSubview(photoView)
    }
    
    func setupConstraints() {
        photoView.easy.layout(
            Top(2),
            Bottom(2),
            Leading(2),
            Trailing(2)
        )
    }
    
    func configure(with url: URL) {
        self.url = url
        photoView.sd_setImage(with: url)
    }

}
