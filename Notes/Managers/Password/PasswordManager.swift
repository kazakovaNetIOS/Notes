//
//  PasswordManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 28/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

private enum UserDefaultsKeys: String {
    case password = "password"
    case hint = "hint"
}

class PasswordManager {
    
    static var password: Password {
        return Password(password: PasswordManager.passwordValue,
                        hint: PasswordManager.hintValue)
    }
    
    static var passwordValue: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.password.rawValue) ?? ""
    }
    
    static var hintValue: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.hint.rawValue) ?? ""
    }
    
    static func savePassword(_ pass: String?) {
        UserDefaults.standard.set(pass, forKey: UserDefaultsKeys.password.rawValue)
    }
    
    static func saveHint(_ hint: String?) {
        UserDefaults.standard.set(hint, forKey: UserDefaultsKeys.hint.rawValue)
    }
}
