//
//  ProfileMenuCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 11.05.2022.
//

import UIKit
import EasyPeasy

class ProfileMenuCell: ReusableCell {
    var item: ProfileMenuType?
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "Menu", fontType: .normal)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "newspaper")?.template()
        imageView.tintColor = .denim
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
        backgroundColor = .viviRose50
        round(18)
        
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        iconImageView.easy.layout(
            Leading(16),
            CenterY(),
            Width(30),
            Height(36)
        )
        
        titleLabel.easy.layout(
            Leading(24).to(iconImageView, .trailing),
            CenterY()
        )
    }

    func configure(item: ProfileMenuType) {
        self.item = item
        titleLabel.text = item.title()
        iconImageView.image = item.icon()?.template()
    }
}
