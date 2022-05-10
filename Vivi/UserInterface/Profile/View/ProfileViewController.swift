//
//  ProfileViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(title: "Выйти",
                                           style: .plain,
                                           target: self,
                                           action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = logoutButton
        navigationBarWithLogo()
        navigationItem.titleView?.easy.layout(CenterX())

    }

    @objc func logoutPressed() {
        presenter.logout()
    }
}

extension ProfileViewController: ProfileViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
}
