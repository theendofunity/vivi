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
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Профиль", at: 0, animated: false)
        control.insertSegment(withTitle: "Проект", at: 1, animated: false)
        control.selectedSegmentTintColor = .viviRose50
        return control

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
        segmentedControl.round(40)

    }
    
    func setupView() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        addSubview(addressLabel)
        addSubview(segmentedControl)
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
            CenterX()
        )
        
        segmentedControl.easy.layout(
            Top(16).to(addressLabel, .bottom),
            Leading(),
            Trailing(),
            Height(38),
            Bottom()
        )
    }

}
