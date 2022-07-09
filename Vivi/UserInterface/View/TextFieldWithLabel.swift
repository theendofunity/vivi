//
//  TextFieldWithLabel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

protocol TextFieldDelegate: AnyObject {
    func textFieldDidEndEditing(_ textField: UITextField)
}

class TextFieldWithLabel: UIView {
    weak var delegate: TextFieldDelegate?
    
    var model: TextFieldViewModel?
    
    var type: TextFieldType = .unknown
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .denim
        label.font = .mainFont
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .smallTextFont
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
    
    convenience init(model: TextFieldViewModel) {
        self.init(frame: .zero)
        
        self.model = model
        
        configure(with: model)
        textField.delegate = self
        
        setKeyboardType()
    }
    
    func configure(with model: TextFieldViewModel) {
        setPlaceholder(model.type.placeholder())
        setLabelText(model.type.fieldTitle())
        type = model.type
        textField.text = model.value
        textField.isEnabled = model.canEdit
    }
    
    func setupView() {
        addSubview(label)
        addSubview(errorLabel)
        addSubview(textField)
    }
    
    func setupConstraints() {
        label.easy.layout(
            Top(),
            Leading(),
            Trailing()
        )
        
        errorLabel.easy.layout(
            Top(4).to(label, .bottom),
            Leading(),
            Trailing()
        )
        
        textField.easy.layout(
            Top(4).to(errorLabel, .bottom),
            Leading(),
            Trailing(),
            Bottom(),
            Height(32)
        )
    }
    
    func setKeyboardType() {
        if type == .password {
            textField.isSecureTextEntry = true
        }
        switch type {
        case .email:
            textField.keyboardType = .emailAddress
        case .phone:
            textField.keyboardType = .phonePad
        case .password:
            textField.keyboardType = .asciiCapable
        default:
            textField.keyboardType = .default
        }
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
    
    func showError(error: Error) {
        errorLabel.text = error.localizedDescription
    }
    
    func clearError() {
        errorLabel.text = ""
    }
    
    func haveError() -> Bool {
        guard let text = errorLabel.text else { return false }
        return !text.isEmpty
    }
    
    func validate() {
        guard let model = model,
        model.allowValidation,
        model.canEdit else { return }
        
        guard let error = TextFieldValidator.validate(type: type, text: text()) else {
            clearError()
            return
        }
        
        showError(error: error)
    }
}

extension TextFieldWithLabel: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
        model?.value = textField.text ?? ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        clearError()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        clearError()
      
        guard let text = textField.text as? NSString else { return true }
        let textAfterUpdate = text.replacingCharacters(in: range, with: string)
        model?.value = textAfterUpdate
        
        return true
    }
}
