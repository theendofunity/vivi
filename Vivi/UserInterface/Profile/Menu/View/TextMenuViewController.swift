//
//  TextMenuViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import UIKit
import EasyPeasy

class TextMenuViewController: UIViewController {
    var presenter: TextMenuPresenter!
    
    private lazy var button: MainButton = {
        let button = MainButton()
        button.addTarget(button, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarBase()
        
        setupView()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        
        view.addSubview(button)
    }
    
    func setupConstraints() {
        button.easy.layout(
            Bottom(24).to(view.safeAreaLayoutGuide, .bottom),
            Leading(24),
            Trailing(24)
        )
    }
    
    @objc func buttonPressed() {
        presenter.buttonPressed()
    }
}

extension TextMenuViewController: TextMenuViewType {
    func setupTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setupButton(title: String, isHidden: Bool) {
        button.setTitle(title, for: .normal)
        button.isHidden = isHidden
    }
}
