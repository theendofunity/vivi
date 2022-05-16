//
//  ProfileHeaderView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 12.05.2022.
//

import UIKit
import EasyPeasy

class ProfileHeaderView: ReusableSupplementaryView {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.consultation()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var userNameLabel: PlainLabel = {
        let label = PlainLabel(text: "user user", fontType: .normal)
        return label
    }()
    
    private lazy var addressLabel: PlainLabel = {
        let label = PlainLabel(text: "address address", fontType: .small)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.round(55)
        avatarImageView.clipsToBounds = true
    }
    
    func setupView() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        addSubview(addressLabel)
    }
    
    func setupConstraints() {
        avatarImageView.easy.layout(
            Top(16),
            CenterX(),
            Width(110),
            Height(110)
        )
        
        userNameLabel.easy.layout(
            Top(16).to(avatarImageView, .bottom),
            CenterX()
        )
        
        addressLabel.easy.layout(
            Top(16).to(userNameLabel, .bottom),
            CenterX(),
            Bottom()
        )
    }

}
