//
//  CalculatorPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.01.2023.
//

import Foundation

protocol CalculatorViewType: AnyObject {
    func showError(error: Error)
    func showResult(viewModels: [ProjectStepPriceViewModel])
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
            var viewModels: [ProjectStepPriceViewModel] = []
            for step in ProjectStepPriceViewModel.StepNumber.allCases {
                let viewModel = ProjectStepPriceViewModel(square: square,
                                                          projectType: projectType,
                                                          designerRate: designerSallary,
                                                          drawerRate: drawerSallary,
                                                          stepNumber: step)
                viewModels.append(viewModel)
            }
            
            view?.showResult(viewModels: viewModels)
        }
    }
    
    func setProjectType(type: ServiceType) {
        projectType = type
    }
}
