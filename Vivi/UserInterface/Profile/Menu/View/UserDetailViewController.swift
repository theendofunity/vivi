//
//  UserDetailViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.06.2022.
//

import UIKit
import EasyPeasy

class UserDetailViewController: UIViewController {
    var presenter: UserDetailPresenter!
    
    lazy var header: ProfileHeaderView = {
        let view = ProfileHeaderView()
        return view
    }()
    
    lazy var typeLabel: PlainLabel = {
        let label = PlainLabel(text: "Тип пользователя", fontType: .normal)
        return label
    }()
    
    lazy var typeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        for types in UserType.allCases {
            segmentedControl.insertSegment(withTitle: types.rawValue, at: 0, animated: false)
        }
        segmentedControl.backgroundColor = .viviRose50
        segmentedControl.selectedSegmentTintColor = .viviLightBlue
        return segmentedControl
    }()
    
    lazy var projectLabel: PlainLabel = {
        let label = PlainLabel(text: "Проект", fontType: .normal)
        return label
    }()
    
    lazy var projectTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()

        return textField
    }()
    
    lazy var changeButton: MainButton = {
        let button = MainButton()
        button.setTitle("Изменить", for: .normal)
        button.addTarget(self, action: #selector(changeProjectPressed), for: .touchUpInside)
        button.round(8)
        return button
    }()
    
    lazy var projectStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [projectTextField, changeButton])
        stack.axis = .horizontal
        stack.alignment = .bottom
        return stack
    }()
    
    lazy var writeButton: MainButton = {
        let button = MainButton()
        button.setTitle("Написать", for: .normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
        
        presenter.viewLoaded()
    }
    
    func setupNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Сохранить",
                                           style: .plain,
                                           target: self,
                                           action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
        
        navigationBarWithLogo()
    }
    
    func setupView() {
        view.backgroundColor = .background
        
        view.addSubview(header)
        view.addSubview(typeLabel)
        view.addSubview(typeSegmentedControl)
        view.addSubview(projectLabel)
        view.addSubview(projectStack)
        view.addSubview(writeButton)
    }
    
    func setupConstraints() {
        header.easy.layout(
            Top(16).to(view.safeAreaLayoutGuide, .top),
            CenterX()
        )
        
        typeLabel.easy.layout(
            Top(24).to(header, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        typeSegmentedControl.easy.layout(
            Top(16).to(typeLabel, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        projectLabel.easy.layout(
            Top(24).to(typeSegmentedControl, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        projectStack.easy.layout(
            Top(16).to(projectLabel, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        changeButton.easy.layout(
            Width(120),
            Height(40)
        )
        
        writeButton.easy.layout(
            Bottom(16).to(view.safeAreaLayoutGuide, .bottom),
            Leading(24),
            Trailing(24)
        )
    }
    
    @objc func mainButtonPressed() {
        presenter.writeButtonPressed()
    }
    
    @objc func saveButtonPressed() {
        let currentSegment = typeSegmentedControl.selectedSegmentIndex
        guard let currentTitle = typeSegmentedControl.titleForSegment(at: currentSegment) else { return }
        
        let type = UserType(rawValue: currentTitle) ?? .base
        presenter.saveButtonPressed(userType: type)
    }
    
    @objc func changeProjectPressed() {
        presenter.changeProjectButtonPressed()
    }
}

extension UserDetailViewController: UserDetailViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func showSuccess() {
        showAlert(title: "Успешно!", message: "Пользователь изменен") {
            self.navigation()?.popViewController(animated: true)
        }
    }
    
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func setupHeader(user: UserModel) {
        header.update(data: user)
        
        for num in 0..<typeSegmentedControl.numberOfSegments {
            if typeSegmentedControl.titleForSegment(at: num) == user.userType.rawValue {
                typeSegmentedControl.selectedSegmentIndex = num
                return
            }
        }
    }
    
    func setupProject(model: TextFieldViewModel) {
        projectTextField.model = model
        projectTextField.textField.text = model.value
    }
}
