//
//  ChatViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class ChatViewController: UIViewController {
    var presenter: ChatPresenter!
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addButtonPressed))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupNavigationBar()
        
        presenter.viewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewAppeared()
    }
    
    func setupView() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = button
        navigationBarWithLogo()
    }
    
    @objc func addButtonPressed() {
        presenter.addButtonPressed()
    }
}

extension ChatViewController: ChatViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func hideAddButton(isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = .clear

        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = .denim
        }
        navigationBarWithLogo()
    }
}
