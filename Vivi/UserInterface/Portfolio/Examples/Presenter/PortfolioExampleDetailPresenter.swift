//
//  PortfolioExampleDetailPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 18.09.2022.
//

import Foundation

protocol PortfolioExampleDetailViewType: AnyObject {
    func update(example: ProjectExample)
    func setTitles(title: String?, description: String?)
}

class PortfolioExampleDetailPresenter {
    weak var view: PortfolioExampleDetailViewType?
    var example: ProjectExample
    
    init(example: ProjectExample) {
        self.example = example
    }
    
    func viewDidLoad() {
        view?.update(example: example)
        view?.setTitles(title: example.title, description: example.description)
    }
}
