//
//  String + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 07.07.2022.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let beginFromPlus = self.prefix(1) == "+"
        let finalSize =  beginFromPlus ? 12 : 10
        
        if self.count != finalSize {
            return false
        } else {
            var digitString = self
            if beginFromPlus {
                digitString.removeFirst()
            }
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: digitString))
        }
    }
}
