//
//  SecurityViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 15.07.2022.
//

import UIKit
import EasyPeasy

class SecurityViewController: UIViewController {
    var presenter: SecurityPresenter!
    
    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var restoreLabel: PlainLabel = {
        let label = PlainLabel(text: "Смена пароля", fontType: .big)
        return label
    }()
    
    private lazy var oldPassword: TextFieldWithLabel = {
        let model = TextFieldViewModel(type: .oldPassword, value: "")
        let textField = TextFieldWithLabel(model: model)
        return textField
    }()
    
    private lazy var newPassword: TextFieldWithLabel = {
        let model = TextFieldViewModel(type: .newPassword, value: "")
        let textField = TextFieldWithLabel(model: model)
        return textField
    }()
    
    private lazy var changePasswordButton: MainButton = {
        let button = MainButton()
        button.setTitle("Изменить пароль", for: .normal)
        button.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeAccountButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0
        button.setTitle("Удалить аккаунт", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(removeAccountButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .background
        navigationBarBase()
        navigationItem.title = "Безопасность"
        
        view.addSubview(scroll)
        
        scroll.addSubview(restoreLabel)
        scroll.addSubview(oldPassword)
        scroll.addSubview(newPassword)
        scroll.addSubview(changePasswordButton)
        scroll.addSubview(removeAccountButton)
    }
    
    func setupConstraints() {
        scroll.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Bottom().to(view.safeAreaLayoutGuide, .bottom),
            Leading(),
            Trailing(),
            Width().like(view, .width)
        )
        
        restoreLabel.easy.layout(
            Top(24),
            Leading(24)
        )
        
        oldPassword.easy.layout(
            Top(24).to(restoreLabel, .bottom),
            Leading(24),
            Trailing(24).to(scroll, .trailing),
            Width(-48).like(scroll, .width)
        )
        
        newPassword.easy.layout(
            Top(24).to(oldPassword, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        changePasswordButton.easy.layout(
            Top(24).to(newPassword, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        removeAccountButton.easy.layout(
            Top(40).to(changePasswordButton, .bottom),
            Leading(24)
        )
    }
    
    @objc func changePasswordButtonPressed() {
        let fields = [oldPassword, newPassword]
        
        var hasError = false
        
        fields.forEach {
            $0.validate()
            hasError = hasError || $0.haveError()
        }
        
        guard !hasError else { return }
        
        guard let oldPassword = oldPassword.text(),
              let newPassword = newPassword.text() else { return }
        
        changePasswordButton.showLoading()
        presenter.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
    
    @objc func removeAccountButtonPressed() {
        let alert = UIAlertController(title: "Удаление аккаунта", message: "Вы уверены, что хотите удалить аккаунт?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.presenter.removeAccount()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension SecurityViewController: SecurityViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func showError(error: Error) {
        changePasswordButton.hideLoading()
        alertError(error: error)
    }
    
    func showSuccess(message: String) {
        changePasswordButton.hideLoading()
        showAlert(title: "Поздравляем!", message: message)
    }
    
    
}
