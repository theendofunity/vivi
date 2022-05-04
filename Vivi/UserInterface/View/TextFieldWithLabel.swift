//
//  TextFieldWithLabel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

class TextFieldWithLabel: UIView {
    var type: TextFieldType = .unknown
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .denim
        label.font = .mainFont
        return label
    }()
    
    lazy var textField: LineTextField = {
        let textField = LineTextField()
        return textField
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
        addSubview(label)
        addSubview(textField)
    }
    
    func setupConstraints() {
        label.easy.layout(
            Top(),
            Leading(),
            Trailing()
        )
        
        textField.easy.layout(
            Top(16).to(label, .bottom),
            Leading(),
            Trailing(),
            Bottom(),
            Height(32)
        )
    }
    
    func setLabelText(_ text: String) {
        label.text = text
    }
    
    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }
    
    func text() -> String? {
        return textField.text
    }
}
