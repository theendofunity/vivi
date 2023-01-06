//
//  CalculatorViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.01.2023.
//

import UIKit
import EasyPeasy

class CalculatorViewController: UIViewController {
    var presenter: CalculatorPresenter!
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [typeSegmentedControl,
                                                  squareTextField,
                                                  designerTextField,
                                                  drawerTextField,
                                                  calculateButton,
                                                  resultView])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var typeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        for item in ServiceType.allCases {
            control.insertSegment(withTitle: item.rawValue, at: 0, animated: false)
        }
        control.setNumberOfLines(0)
        control.selectedSegmentIndex = 0
        
        control.backgroundColor = .viviRose50
        control.selectedSegmentTintColor = .viviLightBlue
        
        control.addTarget(self, action: #selector(changeProjectType), for: .valueChanged)
        
        return control
    }()
    
    private lazy var squareTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()
        textField.label.text = "Площадь"
        textField.textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var designerTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()
        textField.label.text = "Оклад дизайнера"
        textField.textField.keyboardType = .numberPad

        return textField
    }()
    
    private lazy var drawerTextField: TextFieldWithLabel = {
        let textField = TextFieldWithLabel()
        textField.label.text = "Оклад чертежника"
        textField.textField.keyboardType = .numberPad

        return textField
    }()
    
    private lazy var calculateButton: MainButton = {
        let button = MainButton()
        button.setTitle("Расчитать", for: .normal)
        button.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var resultView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .viviRose50
        view.axis = .vertical
        view.spacing = 8
        view.round(8)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        navigationItem.title = "Калькулятор"
        navigationBarBase()
        view.backgroundColor = .background
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func setupConstraints() {
        let width = UIScreen.main.bounds.width

        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        stackView.easy.layout(
            Top(16),
            Bottom(),
            Width(width - 32),
            CenterX()
        )
    }
}

extension CalculatorViewController {
    @objc func calculateButtonPressed() {
        guard let square = squareTextField.text(),
              let designerSallary = designerTextField.text(),
              let drawerSallary = drawerTextField.text()
        else {
            let error = ValidationError.empty
            showError(error: error)
            return
        }
        
        presenter.calculate(square: square, designerSallary: designerSallary, drawerSallary: drawerSallary)
    }
    
    @objc func changeProjectType() {
        let index = typeSegmentedControl.selectedSegmentIndex
        if let title = typeSegmentedControl.titleForSegment(at: index),
            let type = ServiceType(rawValue: title) {
            presenter.setProjectType(type: type)
        }
    }
}
extension CalculatorViewController: CalculatorViewType {
    func showResult(viewModels: [ProjectStepPriceViewModel]) {
        for view in resultView.arrangedSubviews {
            resultView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for viewModel in viewModels {
            let stepView = StepCalculationView()
            stepView.configure(viewModel: viewModel)
            resultView.addArrangedSubview(stepView)
        }
    }
    
    func showError(error: Error) {
       alertError(error: error)
    }
}
