//
//  PortfolioPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import Foundation
import UIKit

protocol PortfolioViewType: AnyObject {
    func setServices(services: [ServiceType])
    func navigationController() -> UINavigationController?
}

class PortfolioPresenter {
    weak var view: PortfolioViewType?
        
    func viewDidLoad() {
        configureServices()
    }
    
    func configureServices() {
        view?.setServices(services: ServiceType.allCases)
    }
    
    func serviceDidSelect(service: ServiceType) {
        let serviceDetails = ServiceDetailsViewController(serviceType: service)
        view?.navigationController()?.present(serviceDetails, animated: true)
    }
}
