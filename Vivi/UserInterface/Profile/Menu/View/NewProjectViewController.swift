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
    
    lazy var typeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        for item in ServiceType.allCases {
            control.insertSegment(withTitle: item.rawValue, at: 0, animated: false)
        }
        control.setNumberOfLines(0)
        control.selectedSegmentIndex = 0
        
        control.backgroundColor = .viviRose50
        control.selectedSegmentTintColor = .viviLightBlue
        
        return control
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
        hideKeyboardWhenTappedAround()
        
        presnter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        
        view.addSubview(fieldsStack)
        view.addSubview(typeSegmentedControl)
        view.addSubview(addButton)
    }
    
    func setupConstraints() {
        fieldsStack.easy.layout(
            Top(16),
            Leading(24),
            Trailing(24)
        )
        
        typeSegmentedControl.easy.layout(
            Top(16).to(fieldsStack, .bottom),
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
        guard let title = fieldsStack.text(for: .title),
              let address = fieldsStack.text(for: .address),
              let square = fieldsStack.text(for: .square),
              let type = fieldsStack.text(for: .type),
              let serviceType = ServiceType(rawValue: typeSegmentedControl.titleForSegment(at: typeSegmentedControl.selectedSegmentIndex) ?? ""),
              let id = UserService.shared.user?.id
        else { return }
        
        let model = ProjectModel(title: title,
                                 address: address,
                                 square: Decimal(string: square) ?? 0,
                                 type: type,
                                 serviceType: serviceType,
                                 users: [id])
        presnter.save(project: model)
    }

}

extension NewProjectViewController: NewProjectViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func showSuccess() {
        showAlert(title: "Сделяль!" , message:  "проект успешно добавлен") {
            self.dismiss(animated: true)
        }
    }
    
    func setupFields(fields: [TextFieldViewModel]) {
        fieldsStack.setFields(fields: fields)
    }
}

extension NewProjectViewController: TextFieldsStackViewDelegate {
    func textFieldEndEditing(textField: UITextField) {
        
    }
    
    func textFieldBeginEditing(textField: UITextField) {
    }
}
