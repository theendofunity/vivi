//
//  NewExampleViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import UIKit

class NewExampleViewController: UIViewController {
    var presenter: NewExamplePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        
    }
    
    func setupConstraints() {
        
    }
}

extension NewExampleViewController: NewExampleViewType {
    
}
