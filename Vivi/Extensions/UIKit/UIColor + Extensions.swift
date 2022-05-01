//
//  UIColor + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let r, g, b: CGFloat
        r = CGFloat(red) / 255.0
        g = CGFloat(green) / 255.0
        b = CGFloat(blue) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
