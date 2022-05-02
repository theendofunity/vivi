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
    
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            alpha: a
        )
    }
}

//MARK: - Main colors

extension UIColor {
    var denim: UIColor? {
        return UIColor(hex: 0x172038)
    }
    
    var viviRose: UIColor? {
        return UIColor(hex: 0xDCAAAA)
    }
    
    var viviRose50: UIColor? {
        return viviRose?.withAlphaComponent(0.5)
    }
    
    var viviRose70: UIColor? {
        return viviRose?.withAlphaComponent(0.7)
    }
    
    var background: UIColor? {
        return UIColor(hex: 0xF5ECEC)
    }
    
    var viviGreen: UIColor? {
        return UIColor(hex: 0x4A7574)
    }
}
