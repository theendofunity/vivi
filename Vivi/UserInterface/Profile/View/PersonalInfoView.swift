//
//  PersonalInfoView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 21.05.2022.
//

import UIKit
import EasyPeasy

protocol PersonalInfoViewDelegate: AnyObject {
    func saveButtonPressed(models: [TextFieldViewModel])
    func securityButtonPressed()
    func showError(error: Error)
}

class PersonalInfoView: UIView {
    weak var delegate: PersonalInfoViewDelegate?
    
    private lazy var textFieldsView: TextFieldsStackView = {
        let view = TextFieldsStackView()
        return view
    }()
    
    private lazy var securityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Безопасность", for: .normal)
        button.setTitleColor(.denim, for: .normal)
        button.titleLabel?.font = .mainFont
        button.titleLabel?.textAlignment = .left
        button.layer.borderWidth = 0
        
        let line = UIView()
        line.backgroundColor = .denim
        button.addSubview(line)
        line.easy.layout(
            Bottom(),
            Leading(),
            Trailing(),
            Height(1)
        )
        
        button.titleLabel?.easy.layout(
            Leading()
        )
        
        button.addTarget(self, action: #selector(securityButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var saveButton: MainButton = {
        let button = MainButton()
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
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
        addSubview(textFieldsView)
        addSubview(securityButton)
        addSubview(saveButton)
    }
    
    func setupConstraints() {
        textFieldsView.easy.layout(
            Top(),
            Leading(24),
            Trailing(24)
        )
        
        securityButton.easy.layout(
            Top(24).to(textFieldsView, .bottom),
            Leading(24),
            Trailing(24),
            Height(40)
        )
        
        saveButton.easy.layout(
            Top(24).to(securityButton, .bottom),
            Leading(24),
            Trailing(24),
            Bottom()
        )
    }

    @objc func saveButtonPressed() {
        if let error = textFieldsView.validate() {
            delegate?.showError(error: error)
            return
        }
        
        let models = textFieldsView.editableFields()
        delegate?.saveButtonPressed(models: models)
    }
    
    @objc func securityButtonPressed() {
        delegate?.securityButtonPressed()
    }
    
    func setupFields(fields: [TextFieldViewModel]) {
        textFieldsView.setFields(fields: fields)
    }
}
