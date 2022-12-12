//
//  ChatCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.06.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class ChatCell: ReusableCell {
    var chat: ChatModel?
    
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
    
    private lazy var unreadView: UIView = {
        let view = UIView()
        view.backgroundColor = .viviRose
        view.round(4)
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
        addSubview(titlesStack)
        addSubview(unreadView)
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
        
        unreadView.easy.layout(
            Trailing(8),
            CenterY(),
            Width(8),
            Height(8)
        )
    }

    func configure(chat: ChatModel) {
        self.chat = chat
        titleLabel.text = chat.displayTitle()
        subtitleLabel.text = chat.lastMessage?.content
        unreadView.isHidden = chat.lastMessage?.isReadedByMe() ?? true
        if let urlString = chat.avatarUrl,
           !urlString.isEmpty {
            photoView.sd_setImage(with: URL(string: urlString))
        }
    }
}
