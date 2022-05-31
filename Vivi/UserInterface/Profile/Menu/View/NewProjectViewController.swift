//
//  NewProjectViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 31.05.2022.
//

import UIKit
import EasyPeasy

class NewProjectViewController: UIViewController {
    var presnter: NewProjectPresenter!
    
    lazy var fieldsStack: TextFieldsStackView = {
        let stack = TextFieldsStackView()
        stack.delegate = self
        return stack
    }()
    
    lazy var addButton: MainButton = {
        let button = MainButton()
        button.setTitle("Добавить", for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        
        presnter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        
        view.addSubview(fieldsStack)
        view.addSubview(addButton)
    }
    
    func setupConstraints() {
        fieldsStack.easy.layout(
            Top(16),
            Leading(24),
            Trailing(24)
        )
        
        addButton.easy.layout(
            Leading(24),
            Trailing(24),
            Bottom(8).to(view.safeAreaLayoutGuide, .bottom)
        )
    }
    
    @objc func addButtonPressed() {
//        guard let title = fieldsStack.text(for: .title),
//              let address = fieldsStack.text(for: .address),
//              let square = fieldsStack.text(for: .square),
//              let type = fieldsStack.text(for: .type) else { return }
    }

}

extension NewProjectViewController: NewProjectViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func showSuccess() {
        showAlert(title: "Сделяль!" , message:  "проект успешно добавлен") {
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    func setupFields(fields: [TextFieldViewModel]) {
        fieldsStack.setFields(fields: fields)
    }
}

extension NewProjectViewController: TextFieldsStackViewDelegate {
    func textFieldBeginEditing(textField: UITextField) {
    }
    
    func textFieldEndEditing() {
    }
}
