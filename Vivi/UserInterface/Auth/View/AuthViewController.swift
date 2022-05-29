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
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .viviRose50
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.logo())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var fieldsView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.round(40)
        return view
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "Авторизация", fontType: .big)
        return label
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
        button.addTarget(self, action: #selector(signInButtonDidTouch), for: .touchUpInside)
        return button
    }()
    
    private lazy var inviteLabel: PlainLabel = {
        let label = PlainLabel(text: "Еще нет аккаунта?", fontType: .small)
        label.textColor = .denim?.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.denim, for: .normal)
        button.addTarget(self, action: #selector(registerButtonDidTouch), for: .touchUpInside)
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
        view.backgroundColor = .background
        view.addSubview(backgroundView)
        view.addSubview(logoImageView)
        view.addSubview(fieldsView)
        fieldsView.addSubview(titleLabel)
        fieldsView.addSubview(emailTextField)
        fieldsView.addSubview(passwordTextField)
        fieldsView.addSubview(signInButton)
        fieldsView.addSubview(inviteLabel)
        fieldsView.addSubview(registerButton)
    }
    
    func setupConstraints() {
        backgroundView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        logoImageView.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            CenterX(),
            Width(142),
            Height(123)
        )
        
        fieldsView.easy.layout(
            Top(40).to(logoImageView),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        titleLabel.easy.layout(
            Top(24),
            CenterX()
        )
        
        emailTextField.easy.layout(
            Top(24).to(titleLabel, .bottom),
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
            Leading(24)
        )
        
        inviteLabel.easy.layout(
            Bottom(4).to(registerButton, .top),
            Leading(24)
        )
    }
    
    @objc func registerButtonDidTouch() {
        presenter.registerButtonDidTouch()
    }
    
    @objc func signInButtonDidTouch() {
        guard let email = emailTextField.text(),
              let password = passwordTextField.text() else {
            return
        }
        
        presenter.signInButtonDidTouch(email: email, password: password)
    }
}

extension AuthViewController: AuthViewType {
    func startAnimation() {
        signInButton.showLoading()
    }
    
    func stopAnimation() {
        signInButton.hideLoading()
    }
    
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func showSuccess() {
        showAlert(title: "Поздравляем!", message: "Вы успешно авторизованы")
    }
}
