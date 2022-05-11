//
//  SceneDelegate.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        FirebaseApp.configure()
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()
        
        let appPresenter = ApplicationPresenter()
        appPresenter.delegate = self
        appPresenter.start()
    }
}

extension SceneDelegate: ApplicationPresenterDelegate {
    func dataLoaded() {
        window?.rootViewController = MainTabBarController()
    }
}

