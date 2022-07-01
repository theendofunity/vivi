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
    static var denim: UIColor? {
        return UIColor(hex: 0x172038)
    }
    
    static var viviRose: UIColor? {
        return UIColor(hex: 0xDCAAAA)
    }
    
    static var viviRose50: UIColor? {
        return viviRose?.withAlphaComponent(0.5)
    }
    
    static var viviRose70: UIColor? {
        return viviRose?.withAlphaComponent(0.7)
    }
    
    static var background: UIColor? {
        return UIColor(hex: 0xF5ECEC)
    }
    
    static var viviGreen: UIColor? {
        return UIColor(hex: 0x4A7574)
    }
    
    static var tabbarRose: UIColor? {
        return UIColor(hex: 0x9B6D6E)
    }
    
    static var viviLightRose: UIColor? {
        return UIColor(hex: 0xDCAAAA)
    }
    
    static var viviLightBlue: UIColor? {
        return UIColor(hex: 0x536872).withAlphaComponent(0.3)
    }
}
