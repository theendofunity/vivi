//
//  TextFieldsStackView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 21.05.2022.
//

import UIKit
import EasyPeasy

protocol TextFieldsStackViewDelegate: AnyObject {
    
}

class TextFieldsStackView: UIView {
    weak var delegate: TextFieldsStackViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
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
        addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.easy.layout(
            Top(),
            Bottom(),
            Leading(),
            Trailing()
        )
    }
}

extension TextFieldsStackView {
    func getFieldWithType(_ type: TextFieldType) -> TextFieldWithLabel? {
        return stackView.arrangedSubviews.first(where: {
            guard let textField = $0 as? TextFieldWithLabel else { return false }
            return textField.type == type
        }) as? TextFieldWithLabel
    }
    
    func text(for type: TextFieldType) -> String? {
        return getFieldWithType(type)?.text()
    }
    
    func setFields(fields: [TextFieldType]) {
        clear()
        
        for field in fields {
            let textField = TextFieldWithLabel()
            textField.setPlaceholder(field.placeholder())
            textField.setLabelText(field.fieldTitle())
            textField.type = field
            
            stackView.addArrangedSubview(textField)
        }
    }
    
    private func clear() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
