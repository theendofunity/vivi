//
//  PersonalInfoView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 21.05.2022.
//

import UIKit
import EasyPeasy

class PersonalInfoView: UIView {

    private lazy var textFieldsView: TextFieldsStackView = {
        let view = TextFieldsStackView()
        return view
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
        addSubview(saveButton)
    }
    
    func setupConstraints() {
        textFieldsView.easy.layout(
            Top(),
            Leading(24),
            Trailing(24)
        )
        
        saveButton.easy.layout(
            Top(24).to(textFieldsView, .bottom),
            Leading(24),
            Trailing(24),
            Bottom()
        )
    }

    @objc func saveButtonPressed() {
        
    }
    
    func setupFields(fields: [TextFieldType]) {
        textFieldsView.setFields(fields: fields)
    }
}
