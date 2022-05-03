//
//  AuthViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

class AuthViewController: UIViewController {
    var presenter: AuthPresenter!
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "Авторизация", fontType: .big)
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.logo())
        imageView.contentMode = .scaleAspectFit
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
    
    private lazy var signInButton: MainButton = {
        let button = MainButton()
        button.setTitle("Войти", for: .normal)
        return button
    }()
    
    private lazy var inviteLabel: PlainLabel = {
        let label = PlainLabel(text: "Еще нет аккаунта?", fontType: .small)
        return label
    }()
    
    private lazy var registerButton: MainButton = {
        let button = MainButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarBase()
        hideKeyboardWhenTappedAround()
        setupView()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(inviteLabel)
        view.addSubview(registerButton)
    }
    
    func setupConstraints() {
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
        
        emailTextField.easy.layout(
            Top(24).to(logoImageView),
            Leading(24),
            Trailing(24)
        )
        
        passwordTextField.easy.layout(
            Top(24).to(emailTextField),
            Leading(24),
            Trailing(24)
        )
        
        signInButton.easy.layout(
            Top(24).to(passwordTextField),
            Leading(24),
            Trailing(24)
        )
        
        
        registerButton.easy.layout(
            Bottom(40).to(view.safeAreaLayoutGuide, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        inviteLabel.easy.layout(
            Bottom(16).to(registerButton, .top),
            Leading(24)
        )
    }
}

extension AuthViewController: AuthViewType {
    
}
