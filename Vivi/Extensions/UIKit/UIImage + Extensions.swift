//
//  UIImage + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit

extension UIImage {
    func template() -> UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
}
