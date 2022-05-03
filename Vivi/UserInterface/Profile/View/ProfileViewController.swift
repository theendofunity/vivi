//
//  ProfileViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarWithLogo()
        
        presenter.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension ProfileViewController: ProfileViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
}
