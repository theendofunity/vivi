//
//  RegistrationPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 04.05.2022.
//

import Foundation

protocol RegistrationViewType: AnyObject {
    func setFields(fields: [TextFieldType])
}

class RegistrationPresenter {
    weak var view: RegistrationViewType?
    
    func viewDidLoad() {
        createFields()
    }
    
    func createFields() {
        let fields = TextFieldType.allCases.filter {
            $0 != .unknown
        }
        view?.setFields(fields: fields)
    }
}
