//
//  CalculatorPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.01.2023.
//

import Foundation

protocol CalculatorViewType: AnyObject {
    func showError(error: Error)
    func showSteps(viewModels: [ProjectPriceModel])
    func showResult(viewModel: ProjectPriceModel)
}

class CalculatorPresenter {
    weak var view: CalculatorViewType?
    var projectType: ServiceType = .fullProject
    
    func calculate(square: String, designerSallary: String, drawerSallary: String) {
       guard let square = Int(square),
             let designerSallary = Int(designerSallary),
             let drawerSallary = Int(drawerSallary)
        else {
           let error = ValidationError.incorretValue
           view?.showError(error: error)
           return
       }
        
        if projectType.isPriceForUnit() {
            var viewModels: [ProjectPriceModel] = []
            let totalStepsCount = projectType.stepsCount()
            
            for step in 0..<totalStepsCount {
                let calculator = ProjectStepPriceCalculator(square: square,
                                                          projectType: projectType,
                                                          designerRate: designerSallary,
                                                          drawerRate: drawerSallary,
                                                          stepNumber: ProjectStepPriceCalculator.StepNumber.allCases[step])
                viewModels.append(calculator.calculate())
            }
            
            view?.showSteps(viewModels: viewModels)
            
            let result = ProjectPriceModel(viewModels: viewModels)
            view?.showResult(viewModel: result)
        }
    }
    
    func setProjectType(type: ServiceType) {
        projectType = type
    }
}
