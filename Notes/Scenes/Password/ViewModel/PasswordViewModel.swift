//
//  PasswordViewModel.swift
//  Notes
//
//  Created by Natalia Kazakova on 28/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class PasswordViewModel {
    
    var password: Password! {
        didSet {
            passwordValue = Box(password.password)
            hintValue = Box(password.hint)
        }
    }
    var passwordValue: Box<String?> = Box(nil)
    var hintValue: Box<String?> = Box(nil)
}

//MARK: - PasswordViewModelType
/***************************************************************/

extension PasswordViewModel: PasswordViewModelType {
    func save() {
        PasswordManager.savePassword(self.passwordValue.value)
        PasswordManager.saveHint(self.hintValue.value)
    }
}
