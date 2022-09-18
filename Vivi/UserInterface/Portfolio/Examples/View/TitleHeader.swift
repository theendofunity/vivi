//
//  TitleHeader.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 17.09.2022.
//

import UIKit
import EasyPeasy

class TitleHeader: ReusableSupplementaryView {
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .normal)
        label.text = "TEST label"
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
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.easy.layout(Leading(), Trailing(), Top(), Bottom())
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
