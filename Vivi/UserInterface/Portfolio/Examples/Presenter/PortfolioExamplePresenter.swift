//
//  PortfolioExamplePresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 28.08.2022.
//

import Foundation

protocol PortfolioExampleViewType: AnyObject {
    func updateView(examples: [ProjectExample])
    func showAddButton()
}

class PortfolioExamplePresenter {
    enum ExampleType {
        case showing
        case editing
    }
    
    var type: ExampleType
    var isEditable: Bool {
        return type == .editing
    }
    weak var view: PortfolioExampleViewType?
    var examples: [ProjectExample]
    
    init(examples: [ProjectExample], type: ExampleType = .showing) {
        self.examples = examples
        self.type = type
    }
    
    func viewDidLoad() {
        if isEditable {
            view?.showAddButton()
        }
        
        view?.updateView(examples: examples)
    }
    
    func addButtonPressed() {
        
    }
}
