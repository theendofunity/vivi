//
//  NewExamplePresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import Foundation
import UIKit

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

extension NewExamplePresenter {
    func addImage(image: UIImage, section: NewExampleSection) {
        var item = ProjectExampleChapterItem()
        item.image = image
        
        switch section {
        case .drafts:
            example.drafts.images.insert(item, at: 0)
        case .visualisations:
            example.visualisations.images.insert(item, at: 0)
        case .result:
            example.result.images.insert(item, at: 0)
        }
        
        view?.update(model: example)
    }
}
