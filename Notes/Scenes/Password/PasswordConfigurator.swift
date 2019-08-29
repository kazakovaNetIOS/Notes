//
//  PasswordConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 28/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol PasswordConfigurator {
    func configure(passwordViewController: PasswordViewController)
}

class PasswordConfiguratorImpl { }

//MARK: - EditNoteConfigurator
/***************************************************************/

extension PasswordConfiguratorImpl: PasswordConfigurator {
    func configure(passwordViewController: PasswordViewController) {
        let viewModel = PasswordViewModel()
        viewModel.password = PasswordManager.password
        
        passwordViewController.viewModel = viewModel
    }
}
