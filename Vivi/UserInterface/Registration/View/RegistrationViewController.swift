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
    
    private lazy var textFieldsView: TextFieldsStackView = {
        let view = TextFieldsStackView()
        view.delegate = self
        return view
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
        mainView.addSubview(textFieldsView)
        mainView.addSubview(termsStack)
        mainView.addSubview(registerButton)
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
        
        textFieldsView.easy.layout(
            Top(24).to(titleLabel, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        termsStack.easy.layout(
            Top(24).to(textFieldsView, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        registerButton.easy.layout(
            Top(24).to(termsStack, .bottom),
            Leading(24),
            Trailing(24),
            Bottom(24)
        )
    }
    
    func getText(_ type: TextFieldType) -> String? {
        return textFieldsView.text(for: type)
    }
    
    @objc func registerButtonPressed() {
        guard let email = getText(.email),
              let password = getText(.password),
              let firstName = getText(.name),
              let lastName = getText(.lastName),
              let city = getText(.city),
              let phone = getText(.phone)
        else { return }
        
        presenter.registerButtonPressed(email: email,
                                        password: password,
                                        firstName: firstName,
                                        lastName: lastName,
                                        middleName: getText(.middleName),
                                        phone: phone,
                                        city: city)
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
        textFieldsView.setFields(fields: fields)
    }
}

extension RegistrationViewController: TextFieldsStackViewDelegate {
    
}
