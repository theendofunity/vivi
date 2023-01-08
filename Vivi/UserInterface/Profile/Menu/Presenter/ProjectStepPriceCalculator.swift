//
//  ProjectStepPriceViewModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.01.2023.
//

import Foundation

struct ProjectStepPriceCalculator {
    enum StepNumber: String, CaseIterable {
        case first = "Первый"
        case second = "Второй"
        case third = "Третий"
    }
    
    enum SquareLevel: Int {
        case small = 50
        case medium = 100
        case big = 150
        case other = 200
    }
    
    var projectType: ServiceType
    let square: Int
    let fullPrice: Int
    let designerRate: Int
    let drawerRate: Int
    let totalStepsCount: Int
    
    let stepPrice: CGFloat
    
    var stepNumber: StepNumber = .first
    
    let squareLevel: SquareLevel
    
    init(square: Int, projectType: ServiceType, designerRate: Int, drawerRate: Int, stepNumber: StepNumber) {
        self.projectType = projectType
        self.square = square
        self.designerRate = designerRate
        self.drawerRate = drawerRate
        self.stepNumber = stepNumber
        totalStepsCount = projectType.stepsCount()
        
        fullPrice = square * projectType.priceForUnit()
        stepPrice = CGFloat(fullPrice / totalStepsCount)
        
        if square < SquareLevel.small.rawValue {
            squareLevel = .small
        } else if square < SquareLevel.medium.rawValue {
            squareLevel = .medium
        } else if square < SquareLevel.big.rawValue {
            squareLevel = .big
        } else {
            squareLevel = .other
        }
    }
    
    func calculate() -> ProjectPriceModel {
        let model = ProjectPriceModel(viewModel: self)
        return model
    }
    
    func meassureSallary() -> CGFloat {
        var sum: CGFloat = 0
        if stepNumber == .first {
            switch squareLevel {
            case .small:
                sum = 1500
            case .medium:
                sum = 2000
            case .big:
                sum = 2500
            case .other:
                sum = 3000
            }
        }
        return sum
    }
    
    func designerSallary() -> CGFloat {
        return CGFloat(designerRate * square / totalStepsCount)
    }
    
    func drawerSallary() -> CGFloat {
        return CGFloat(drawerRate * square / totalStepsCount)
    }
    
    func visualisatorSallary() -> CGFloat {
        if projectType == .fullProject {
            let needVisualisation = stepNumber == .first || stepNumber == .second
            if needVisualisation {
                let rate = 450
                
                return CGFloat(rate * square / 2)
            }
        }
        
       return 0
    }
    
    func printSallary() -> CGFloat {
        if stepNumber == .third {
            return 2500
        } else {
            return 0
        }
    }
    
    func costs() -> CGFloat {
        return meassureSallary() + designerSallary() + drawerSallary() + visualisatorSallary() + printSallary()
    }
    
    func profit() -> CGFloat {
        let costs = costs()
        return stepPrice - costs
    }
}
