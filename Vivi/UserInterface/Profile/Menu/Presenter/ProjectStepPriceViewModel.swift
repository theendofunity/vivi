//
//  ProjectStepPriceViewModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.01.2023.
//

import Foundation

struct ProjectStepPriceViewModel {
    enum StepNumber: String, CaseIterable {
        case first = "Первый"
        case second = "Второй"
        case third = "Третий"
    }
    
    var projectType: ServiceType
    let square: Int
    let fullPrice: Int
    let designerRate: Int
    let drawerRate: Int
    
    let stepPrice: CGFloat
    
    var stepNumber: StepNumber = .first
    
    init(square: Int, projectType: ServiceType, designerRate: Int, drawerRate: Int, stepNumber: StepNumber) {
        self.projectType = projectType
        self.square = square
        self.designerRate = designerRate
        self.drawerRate = drawerRate
        self.stepNumber = stepNumber
        
        fullPrice = square * projectType.priceForUnit()
        stepPrice = CGFloat(fullPrice / StepNumber.allCases.count)
    }
    
    func meassureSallary() -> CGFloat {
        if stepNumber == .first {
            return 1500
        } else {
            return 0
        }
    }
    
    func designerSallary() -> CGFloat {
        return CGFloat(designerRate * square / StepNumber.allCases.count)
    }
    
    func drawerSallary() -> CGFloat {
        return CGFloat(drawerRate * square / StepNumber.allCases.count)
    }
    
    func visualisatorSallary() -> CGFloat {
        let rate = 450
        
        return CGFloat(rate * square / StepNumber.allCases.count)
    }
    
    
    func printSallary() -> CGFloat {
        return 2500
    }
    
    func costs() -> CGFloat {
        return stepPrice - meassureSallary() - designerSallary() - drawerSallary() - visualisatorSallary() - printSallary()
    }
    
    func profit() -> CGFloat {
        let costs = costs()
        return stepPrice - costs
    }
    
    
}
