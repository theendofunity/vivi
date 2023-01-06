//
//  StepCalculationView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.01.2023.
//

import UIKit
import EasyPeasy

class StepCalculationView: UIView {
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "", fontType: .big)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(stack)
    }
    
    func setupConstraints() {
        titleLabel.easy.layout(
            Top(8),
            Leading(8),
            Trailing(8)
        )
        
        stack.easy.layout(
            Top(16).to(titleLabel),
            Leading(16),
            Trailing(16),
            Bottom(8)
        )
    }

    func addLabel(text: String) {
        let label = PlainLabel(text: text, fontType: .normal)
            
        stack.addArrangedSubview(label)
    }
    
    func configure(viewModel: ProjectStepPriceViewModel) {
        titleLabel.text = "\(viewModel.stepNumber.rawValue) этап"
        addLabel(text: "Стоимость: \(viewModel.stepPrice)")
        addLabel(text: "Обмеры: \(viewModel.meassureSallary())")
        addLabel(text: "Дизайнер: \(viewModel.designerSallary())")
        addLabel(text: "Чертежник: \(viewModel.drawerSallary())")
        addLabel(text: "Визуализатор: \(viewModel.visualisatorSallary())")
        addLabel(text: "Печать: \(viewModel.printSallary())")

        addLabel(text: "Расходы: \(viewModel.costs())")
        addLabel(text: "Прибыль: \(viewModel.profit())")
    }
}
