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
    
    private lazy var selectionImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "checkmark")?.template()
        view.image = image
        view.tintColor = .denim
        view.isHidden = true
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
        addSubview(selectionImageView)
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
        
        selectionImageView.easy.layout(
            Trailing(),
            CenterY()
        )
    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
    func select() {
        arrowImageView.isHidden.toggle()
        selectionImageView.isHidden.toggle()
    }
    
    func setSelected(isSelected: Bool) {
        arrowImageView.isHidden = isSelected
        selectionImageView.isHidden = !isSelected
    }
}
