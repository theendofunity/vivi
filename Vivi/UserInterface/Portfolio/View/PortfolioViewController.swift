//
//  PortfolioViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

class PortfolioViewController: UIViewController {
    weak var presenter: PortfolioPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension PortfolioViewController: PortfolioViewType {
    
}
