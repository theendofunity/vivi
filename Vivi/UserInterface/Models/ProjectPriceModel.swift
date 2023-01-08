//
//  ProjectPriceModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 09.01.2023.
//

import Foundation

struct ProjectPriceModel {
    var title: String
    
    var meassureSallary: CGFloat = 0
    var designerSallary: CGFloat = 0
    var drawerSallary: CGFloat = 0
    var visualisatorSallary: CGFloat = 0
    var printSallary: CGFloat = 0
    
    var totalPrice: CGFloat = 0
    var totalCost: CGFloat = 0
    var totalProfit: CGFloat = 0
    
    init(viewModel: ProjectStepPriceCalculator) {
        title = viewModel.stepNumber.rawValue + " этап"
        
        meassureSallary = viewModel.meassureSallary()
        designerSallary = viewModel.designerSallary()
        drawerSallary = viewModel.drawerSallary()
        visualisatorSallary = viewModel.visualisatorSallary()
        printSallary = viewModel.printSallary()
        totalPrice = viewModel.stepPrice
        totalCost = viewModel.costs()
        totalProfit = viewModel.profit()
    }
    
    init(viewModels: [ProjectPriceModel]) {
        title = "Результат"
        
        for viewModel in viewModels {
            meassureSallary += viewModel.meassureSallary
            designerSallary += viewModel.designerSallary
            drawerSallary += viewModel.drawerSallary
            visualisatorSallary += viewModel.visualisatorSallary
            printSallary += viewModel.printSallary
            totalPrice += viewModel.totalPrice
            totalCost += viewModel.totalCost
            totalProfit += viewModel.totalProfit
        }
    }
}
