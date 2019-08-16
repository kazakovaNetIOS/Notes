//
//  AuthManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 16/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class AuthManager {
    
    private let tokenKey = "token"
    
    public var delegate: AuthManagerDelegate?
    
    private var token: String? {
        get { return UserDefaults.standard.object(forKey: tokenKey) as? String }
        set { UserDefaults.standard.set(token, forKey: tokenKey) }
    }
}

//MARK: - Authorization check
/***************************************************************/

extension AuthManager {
    public func authCheck() {
        guard token != nil else {
            requestToken()
            return
        }
        delegate?.authPassed()
    }
    
    private func requestToken() {
        let viewController = AuthViewController()
        viewController.delegate = self
        delegate?.show(viewController)
    }
}

//MARK: - AuthViewControllerDelegate
/***************************************************************/

extension AuthManager: AuthViewControllerDelegate {
    func handleRecieved(token: String) {
        self.token = token
    }
}
