//
//  PortfolioPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import Foundation

protocol PortfolioViewType: AnyObject {
    func setServices(services: [ServiceType])
}

class PortfolioPresenter {
    weak var view: PortfolioViewType?
    
    private var services: [ServiceType] = []
    
    func viewDidLoad() {
        configureServices()
    }
    
    func configureServices() {
        services = ServiceType.allCases
        view?.setServices(services: services)
    }
    
    func serviceDidSelect(service: ServiceType) {
        
    }
}
