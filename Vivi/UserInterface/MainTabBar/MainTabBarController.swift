//
//  MainTabBarController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    enum Tab: Int {
        case main = 0
        case chat = 1
        case profile = 2
    }
    
    private var profileTabConfigurator: TabConfigurator?
    private var chatTabConfigurator: TabConfigurator?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        tabBar.tintColor = .tabbarRose
        tabBar.backgroundColor = .background
        tabBar.barTintColor = .background
        tabBar.unselectedItemTintColor = .denim
        
        setupViewControllers()
        updateUnreadBadge()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUnreadBadge), name: .messageReaded, object: nil)
    }
    
    func setupViewControllers() {
        let portfolioPresenter = PortfolioPresenter()
        let portfolioViewController = PortfolioViewController()
        portfolioViewController.presenter = portfolioPresenter
        portfolioPresenter.view = portfolioViewController
        
        let portfolioImage = UIImage(systemName: "photo.on.rectangle")
        let chatImage = UIImage(systemName: "message")
        let profileImage = UIImage(systemName: "person")
        
        let main =  createNavigationController(rootViewController: portfolioViewController, title: "Портфолио", image: portfolioImage)
        let chat = createNavigationController(rootViewController: nil, title: "Чат", image: chatImage)
        let profile = createNavigationController(rootViewController: nil, title: "Профиль", image: profileImage)

        profileTabConfigurator = ProfileTabConfigurator(navigation: profile)
        chatTabConfigurator = ChatTabConfigurator(navigation: chat)
        
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

    func setUnreadBadge(count: Int?) {
        if let items = tabBar.items {
            let chatItem = items[Tab.chat.rawValue]
            if let count = count {
                chatItem.badgeValue = "\(count)"
                chatItem.badgeColor = .viviRose
            } else {
                chatItem.badgeValue = nil
            }
        }
    }
    
    @objc func updateUnreadBadge() {
       let count = DataStore.shared.unreadChats()
        setUnreadBadge(count: count)
    }
}
