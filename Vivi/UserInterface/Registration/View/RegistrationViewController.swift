//
//  RegistrationViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 04.05.2022.
//

import UIKit
import EasyPeasy

class RegistrationViewController: UIViewController {
    var presenter: RegistrationPresenter!
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .viviRose50
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.round(40)
        return view
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "Регистрация", fontType: .big)
        return label
    }()
    
    private lazy var termsSwitch: UISwitch = {
        let termsSwitch = UISwitch()
        termsSwitch.onTintColor = .viviRose
        return termsSwitch
    }()
    
    private lazy var termsLabel: PlainLabel = {
        let label = PlainLabel(text: "Соглашаюсь с условиями", fontType: .small)
        return label
    }()
    
    private lazy var termsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [termsSwitch, termsLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private lazy var registerButton: MainButton = {
        let button = MainButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarWithLogo()
        self.setupView()
        self.setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(stackView)
    }
    
    func setupConstraints() {
        backgroundView.easy.layout(
            Edges(),
            Top().to(view.safeAreaLayoutGuide, .top),
            Bottom()
        )
        
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        mainView.easy.layout(
            Top(24),
            Leading(),
            Trailing(),
            CenterX(),
            Bottom()
        )
        
        titleLabel.easy.layout(
            Top(24),
            CenterX()
        )
        
        stackView.easy.layout(
            Top(24).to(titleLabel, .bottom),
            Leading(24),
            Trailing(24),
            Bottom(40)
        )
    }
    
    @objc func registerButtonPressed() {
        guard let email = getFieldWithType(.email)?.text(),
              let password = getFieldWithType(.password)?.text(),
              let firstName = getFieldWithType(.name)?.text(),
              let lastName = getFieldWithType(.lastName)?.text(),
              let city = getFieldWithType(.city)?.text(),
              let phone = getFieldWithType(.phone)?.text()
        else { return }
        presenter.registerButtonPressed(email: email,
                                        password: password,
                                        firstName: firstName,
                                        lastName: lastName,
                                        middleName: getFieldWithType(.middleName)?.text(),
                                        phone: phone,
                                        city: city)
    }
    
    func getFieldWithType(_ type: TextFieldType) -> TextFieldWithLabel? {
        return stackView.arrangedSubviews.first(where: {
            guard let textField = $0 as? TextFieldWithLabel else { return false }
            return textField.type == type
        }) as? TextFieldWithLabel
    }
}

extension RegistrationViewController: RegistrationViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func showSuccess() {
        showAlert(title: "Поздравляем!", message: "Вы успешно зарегистрированы") {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setFields(fields: [TextFieldType]) {
        for field in fields {
            let textField = TextFieldWithLabel()
            textField.setPlaceholder(field.placeholder())
            textField.setLabelText(field.fieldTitle())
            textField.type = field
            
            stackView.addArrangedSubview(textField)
        }
        stackView.addArrangedSubview(termsStack)
        stackView.addArrangedSubview(registerButton)
    }
}
