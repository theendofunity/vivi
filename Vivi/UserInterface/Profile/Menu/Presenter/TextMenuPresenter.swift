//
//  TextMenuPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import Foundation

protocol TextMenuViewType: AnyObject {
    func setupTitle(_ title: String)
    func setupButton(title: String, isHidden: Bool)
}

class TextMenuPresenter {
    weak var view: TextMenuViewType?
    var type: ProfileMenuType
    
    init(type: ProfileMenuType) {
        self.type = type
    }
    
    func viewDidLoad() {
        view?.setupTitle(type.title())
        setupButton()
    }
    
    func viewDidAppear() {
        
    }
    
    
    func setupButton() {
        view?.setupButton(title: "Добавить", isHidden: false)
    }
    
    func buttonPressed() {
        
    }
}
