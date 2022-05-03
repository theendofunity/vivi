//
//  UIViewController + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

extension UIViewController {
    func navigationBarWithLogo() {
        navigationBarBase()
        
        let logo = R.image.logo()
        let imageView = UIImageView(image: logo)
        imageView.easy.layout(Height(38))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func navigationBarBase() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .viviRose50
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .denim 
        navigationItem.backButtonTitle = ""

    }
    
    func alertError(error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
