//
//  MainTabBarController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let portfolioViewController = PortfolioViewController()
        let portfolioPresenter = PortfolioPresenter()
        portfolioViewController.presenter = portfolioPresenter
        portfolioPresenter.view = portfolioViewController
        let portfolioImage = UIImage(systemName: "photo.on.rectangle")
        
        let chatViewController = ChatViewController()
        let chatPresenter = ChatPresenter()
        chatViewController.presenter = chatPresenter
        chatPresenter.view = chatViewController
        let chatImage = UIImage(systemName: "message")
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        let profileImage = UIImage(systemName: "person")
        
        viewControllers = [
            createNavigationController(rootViewController: portfolioViewController, title: "Портфолио", image: portfolioImage),
            createNavigationController(rootViewController: chatViewController, title: "Чат", image: chatImage),
            createNavigationController(rootViewController: profileViewController, title: "Профиль", image: profileImage)
        ]
    }
    

    func createNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        
        return navigationController
    }
}
