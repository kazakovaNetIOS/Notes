//
//  PasswordCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class PasswordCoordinator {
    
    private let presenter: UINavigationController
    private var passwordViewController: PasswordViewController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
}

//MARK: - Coordinator
/***************************************************************/

extension PasswordCoordinator: Coordinator {
    func start() {
        let passwordViewController = PasswordViewController.instantiateViewController()
        passwordViewController.configurator = PasswordConfiguratorImpl()
      
        presenter.pushViewController(passwordViewController, animated: true)
        
        self.passwordViewController = passwordViewController
    }
}
