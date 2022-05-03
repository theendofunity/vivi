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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .viviRose70
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let logo = R.image.logo()
        let imageView = UIImageView(image: logo)
        imageView.easy.layout(Height(38))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func alertError(error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        present(alert, animated: true)
    }
}
