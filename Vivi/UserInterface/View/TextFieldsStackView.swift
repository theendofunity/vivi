//
//  TextFieldsStackView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 21.05.2022.
//

import UIKit
import EasyPeasy

protocol TextFieldsStackViewDelegate: AnyObject {
    func textFieldBeginEditing(textField: UITextField)
    func textFieldEndEditing(textField: UITextField)
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
    
    func setFields(fields: [TextFieldViewModel]) {
        clear()
        
        for field in fields {
            let textField = TextFieldWithLabel(model: field)
            textField.delegate = self
            stackView.addArrangedSubview(textField)
        }
    }
    
    private func clear() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func validate() -> Error? {
        var haveError = false
        
        for subview in stackView.arrangedSubviews {
            guard let textField = subview as? TextFieldWithLabel else { continue }
            textField.validate()
            if textField.haveError() {
                haveError = true
            }
        }
        return haveError ? ValidationError.emptyFields : nil
    }
}

extension TextFieldsStackView: TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldBeginEditing(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldEndEditing(textField: textField)
    }
}
