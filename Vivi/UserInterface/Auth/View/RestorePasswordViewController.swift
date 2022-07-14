//
//  RestorePasswordViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.07.2022.
//

import UIKit
import EasyPeasy

class RestorePasswordViewController: UIViewController {
    var presenter: RestorePasswordPresenter!
    
    private lazy var emailLabel: PlainLabel = {
        let label = PlainLabel(text: "Введите email, на который зарегистрирован аккаут", fontType: .normal)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textField: LineTextField = {
        let textField = LineTextField()
        return textField
    }()
    
    private lazy var acceptButton: MainButton = {
        let button = MainButton()
        button.setTitle("Восстановить пароль", for: .normal)
        button.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        navigationBarBase()
        navigationItem.title = "Восстановление пароля"
        view.backgroundColor = .background
        
        view.addSubview(emailLabel)
        view.addSubview(textField)
        view.addSubview(acceptButton)
    }
    
    func setupConstraints() {
        emailLabel.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            Leading(24),
            Trailing(24)
        )
        
        textField.easy.layout(
            Top(16).to(emailLabel, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        acceptButton.easy.layout(
            Top(24).to(textField, .bottom),
            Leading(24),
            Trailing(24)
        )
    }
    
    @objc func acceptButtonPressed() {
        guard let email = textField.text else { return }
        acceptButton.showLoading()
        presenter.restoreButtonPressed(email: email)
    }
}

extension RestorePasswordViewController: RestorePasswordViewType {
    func showError(error: Error) {
        acceptButton.hideLoading()
        alertError(error: error)
    }
    
    func showSuccess() {
        acceptButton.hideLoading()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.acceptButton.isHidden = true
            self?.textField.isHidden = true
            self?.emailLabel.text = "На указанный адрес придет письмо с дальнейшими инструкциями"
        }
        
    }
    
    
}
