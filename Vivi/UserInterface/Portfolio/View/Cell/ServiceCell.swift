//
//  ServiceCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class ServiceCell: ReusableCell {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .smallTextFont
        label.text = "fasfasfasf"
        label.numberOfLines = 0
        label.textAlignment = .center
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
        backgroundColor = .viviRose70
        round(8)
        addSubview(title)
    }
    
    func setupConstraints() {
        title.easy.layout(
            Leading(8),
            Trailing(8),
            Top(8)
        )
    }

}
