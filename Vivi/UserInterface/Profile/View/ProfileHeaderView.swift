//
//  ProfileHeaderView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 12.05.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class ProfileHeaderView: UIView {
    enum Position {
        case center
        case left
    }
    
    var position: Position = .center
    
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
    
    private lazy var titlesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        return stack
    }()
    
    convenience init(position: Position = .center) {
        self.init(frame: .zero)
        
        self.position = position
        
        self.setupView()
        self.setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        addSubview(titlesStack)
    }
    
    func setupConstraints() {
        if position == .center {
            avatarImageView.easy.layout(
                Top(16),
                CenterX(),
                Width(110),
                Height(110)
            )
            
            titlesStack.easy.layout(
                Top(16).to(avatarImageView, .bottom),
                CenterX(),
                Bottom()
            )
        } else {
            avatarImageView.easy.layout(
                Top(16),
                Leading(16),
                Width(110),
                Height(110),
                Bottom()
            )
            
            titlesStack.easy.layout(
                Leading(16).to(avatarImageView, .trailing),
                Trailing(),
                CenterY()
            )
        }
    }

    func update<T: HeaderRepresentable>(data: T) {
        userNameLabel.text = data.headerTitle()
        addressLabel.text = data.addressTitle()
        avatarImageView.sd_setImage(with: data.imageUrl(), placeholderImage: R.image.consultation())
    }
}
