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
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = .viviRose50
        return scroll
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    private lazy var orLabel: PlainLabel = {
        let label = PlainLabel(text: "Или", fontType: .small)
        label.textColor = .denim?.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var restorePasswordButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0
        button.setTitle("Восстановить пароль", for: .normal)
        button.setTitleColor(.denim, for: .normal)
        button.addTarget(self, action: #selector(restorePasswordButtonDidTouch), for: .touchUpInside)
        return button
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
        view.backgroundColor = .white //TODO: fix after change colors
        view.addSubview(scrollView)
        
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(logoImageView)
        backgroundView.addSubview(fieldsView)
        
        fieldsView.addSubview(titleLabel)
        fieldsView.addSubview(emailTextField)
        fieldsView.addSubview(passwordTextField)
        fieldsView.addSubview(signInButton)
        fieldsView.addSubview(inviteLabel)
        fieldsView.addSubview(orLabel)
        fieldsView.addSubview(restorePasswordButton)
        fieldsView.addSubview(registerButton)
    }
    
    func setupConstraints() {
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        backgroundView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Bottom(),
            Width().like(scrollView, .width),
            Height(50).like(scrollView, .height)
        )
        
        logoImageView.easy.layout(
            Top(24),
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
        
        inviteLabel.easy.layout(
            Top(40).to(signInButton, .bottom),
            Leading(24)
        )
        
        registerButton.easy.layout(
            Top(4).to(inviteLabel, .bottom),
            Leading(24)
        )
        
        orLabel.easy.layout(
            Top(8).to(registerButton, .bottom),
            Leading(24)
        )
        
        restorePasswordButton.easy.layout(
            Top().to(orLabel, .bottom),
            Leading(24)
        )
    }
    
    @objc func registerButtonDidTouch() {
        presenter.registerButtonDidTouch()
    }
    
    @objc func restorePasswordButtonDidTouch() {
        presenter.restorePasswordDidTouch()
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
