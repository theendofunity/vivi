//
//  UserCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.06.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class UserCell: ReusableCell {
    var user: UserModel?
    
    lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = R.image.consultation()
        view.contentMode = .scaleAspectFill
        view.round(25)
        return view
    }()
    
    lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .normal)
        return label
    }()
    
    lazy var subtitleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .small)
        return label
    }()
    
    lazy var titlesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
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
        addSubview(titlesStack)
    }
    
    func setupConstraints() {
        photoView.easy.layout(
            Leading(),
            CenterY(),
            Width(50),
            Height(50)
        )
        
        titlesStack.easy.layout(
            Leading(16).to(photoView, .trailing),
            CenterY()
        )
    }

    func configure(user: UserModel) {
        self.user = user
        
        if let urlString = user.avatarUrl,
           let url = URL(string: urlString) {
            photoView.sd_setImage(with: url)
        }
        
        titleLabel.text = user.usernameTitle()
        subtitleLabel.text = user.projects.first
    }
}
