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
        let contentView = UIView()
        navigationItem.titleView = contentView
        navigationItem.titleView?.addSubview(imageView)
        imageView.easy.layout(CenterY(), CenterX(), Height(40), Width(55))
    }
    
    func navigationBarBase() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .viviRose50
        
        let attributes = [
          NSAttributedString.Key.foregroundColor: UIColor.denim
        ]
        
        appearance.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .denim
        navigationController?.navigationBar.barTintColor = .denim

        navigationItem.backButtonTitle = ""

    }
    
    func alertError(error: Error) {
        showAlert(title: "Ошибка", message: error.localizedDescription)
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel) { _ in 
            completion?()
        }
        alert.addAction(okButton)
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
