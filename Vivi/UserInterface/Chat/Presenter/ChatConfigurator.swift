//
//  ChatConfigurator.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.11.2022.
//

import Foundation

class ChatTabConfigurator: TabConfigurator {
    override func showContent() {
        let chatViewController = ChatsListViewController()
        let chatPresenter = ChatsListPresenter()
        chatViewController.presenter = chatPresenter
        chatViewController.navigationDelegate = self
        chatPresenter.view = chatViewController
        
        navigation.setViewControllers([chatViewController], animated: true)
    }
}
