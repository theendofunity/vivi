//
//  MainTabBarController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    private var profileConfigurator: ProfileConfigurator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        tabBar.tintColor = .tabbarRose
        tabBar.backgroundColor = .background
        tabBar.barTintColor = .background
        tabBar.unselectedItemTintColor = .denim
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let portfolioPresenter = PortfolioPresenter()
        let portfolioViewController = PortfolioViewController()
        portfolioViewController.presenter = portfolioPresenter
        portfolioPresenter.view = portfolioViewController
        let portfolioImage = UIImage(systemName: "photo.on.rectangle")
        
        let chatViewController = ChatsListViewController()
        let chatPresenter = ChatsListPresenter()
        chatViewController.presenter = chatPresenter
        chatPresenter.view = chatViewController
        let chatImage = UIImage(systemName: "message")
        
        let profileImage = UIImage(systemName: "person")
        
        let main =  createNavigationController(rootViewController: portfolioViewController, title: "Портфолио", image: portfolioImage)
        let chat = createNavigationController(rootViewController: chatViewController, title: "Чат", image: chatImage)
        let profile = createNavigationController(rootViewController: nil, title: "Профиль", image: profileImage)

        profileConfigurator = ProfileConfigurator(navigation: profile)
    
        viewControllers = [
           main,
           chat,
           profile
        ]
    }

    func createNavigationController(rootViewController: UIViewController?, title: String, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController()
        if let rootViewController = rootViewController {
            navigationController.viewControllers = [rootViewController]
        }
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
