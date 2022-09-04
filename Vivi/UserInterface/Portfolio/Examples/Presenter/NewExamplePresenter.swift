//
//  NewExamplePresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import Foundation

protocol NewExampleViewType: AnyObject {
    func update(model: ProjectExample)
}

class NewExamplePresenter {
    weak var view: NewExampleViewType?
    var example = ProjectExample()
    
    func viewDidLoad() {
        setupItems()
    }
    
    func setupItems() {
        view?.update(model: example)
    }
}
