//
//  TextMenuCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import UIKit
import EasyPeasy

class TextMenuCell: ReusableCell {
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "asdasdasd", fontType: .normal)
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "chevron.right")?.template()
        view.image = image
        view.tintColor = .denim
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
        backgroundColor = .background
        addSubview(titleLabel)
        addSubview(arrowImageView)
    }
    
    func setupConstraints() {
        titleLabel.easy.layout(
            Leading(),
            CenterY()
        )
        
        arrowImageView.easy.layout(
            Trailing(),
            CenterY()
        )
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
