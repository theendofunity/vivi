//
//  ProjectCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 09.06.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class ProjectCell: ReusableCell {
    var project: ProjectModel?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .normal)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
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
    
    func setupView() {
        backgroundColor = .background
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        imageView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Width(150),
            Height(150)
        )
        
        titleLabel.easy.layout(
            Top(4).to(imageView),
            Leading(),
            Trailing(),
            Bottom(8)
        )
    }

    func configure(project: ProjectModel) {
        self.project = project
        print(project.documentId())
        titleLabel.text = project.documentId()
        imageView.sd_setImage(with: project.imageUrl(), placeholderImage: R.image.logo())
    }
}
