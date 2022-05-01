//
//  ProfileViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    weak var presenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ProfileViewController: ProfileViewType {
    
}
