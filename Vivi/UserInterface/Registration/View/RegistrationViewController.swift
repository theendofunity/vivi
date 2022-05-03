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
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "Регистрация", fontType: .big)
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.logo())
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var emailTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()
        textField.setPlaceholder("Введите email")
        textField.setLabelText("Email")
        return textField
    }()
    
    private lazy var passwordTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()
        textField.setPlaceholder("Введите пароль")
        textField.setLabelText("Пароль")
        return textField
    }()
    
    private lazy var phoneTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()
        textField.setPlaceholder("Введите номер телефона")
        textField.setLabelText("Номер телефона")
        return textField
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
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            phoneTextField,
            termsStack,
            registerButton
        ])
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(stackView)
    }
    
    func setupConstraints() {
        scrollView.easy.layout(Edges(), Width(UIScreen.main.bounds.width))
        
        titleLabel.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            CenterX()
        )
        
        logoImageView.easy.layout(
            Top(40).to(titleLabel, .bottom),
            CenterX(),
            Width(142),
            Height(123)
        )
        
        stackView.easy.layout(
            Top(24).to(logoImageView, .bottom),
            Leading(24),
            Trailing(24),
            Bottom(),
            CenterX()
        )
    }
}

extension RegistrationViewController: RegistrationViewType {
    
}
