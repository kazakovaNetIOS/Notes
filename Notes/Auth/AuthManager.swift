//
//  AuthManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 16/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import WebKit

protocol AuthManagerDelegate {
    func show(_ authController: AuthControllerProtocol)
    func authPassed()
}

class AuthManager {
    
    public static let shared = AuthManager()
    public var delegate: AuthManagerDelegate?
    private var controller: AuthViewController?

    public private(set) var token: String? {
        get { return UserDefaults.standard.object(forKey: "token") as? String }
        set { UserDefaults.standard.set(newValue, forKey: "token") }
    }
    
    private init() {}
}

//MARK: - Constants
/***************************************************************/

extension AuthManager {
    private enum Constants {
        static let tokenKey = "token"
        static let clientId = "7aaddc81018489f6f650"
        static let clientSecret = "2180fd1eec8ff98450d5156ff0ddae588dc6aa05"
        static let scheme = "notes"
        static let scope = "gist"
        static let tokenUrlString = "https://github.com/login/oauth/access_token"
        static let codeUrlString = "https://github.com/login/oauth/authorize"
        static let gitHubDomain = "https://github.com/"
    }
}

//MARK: - Public
/***************************************************************/

extension AuthManager {
    public func authCheck() {
        if token == nil { showAuthController() }
        else { delegate?.authPassed() }
    }
    
    public func process(_ navigationAction: WKNavigationAction,
                        _ decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
            url.scheme == Constants.scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                requestToken(with: code)
            }
        }
        do {
            decisionHandler(.allow)
        }
    }
}

//MARK: - Private
/***************************************************************/

extension AuthManager {
    private func showAuthController() {
        guard let request = getRequestAuthCode() else { return }
        
        controller = AuthViewController(request: request)
        delegate?.show(controller!)
    }
    
    private func requestToken(with code: String) {
        guard let request = getRequestAuthToken(with: code) else { return }
        
        NetworkManager.shared.delegate = self
        NetworkManager.shared.sendRequest(with: request) { [weak self] (data, _) in
            guard let `self` = self else { return }
            guard let responseString = String(data: data, encoding: .utf8) else { return }
            
            let components = URLComponents(string: "\(Constants.gitHubDomain)?\(responseString)")
            self.token = components?.queryItems?.first(where: { $0.name == "access_token" })?.value
        }
    }
}

//MARK: - Get requests
/***************************************************************/

extension AuthManager {
    private func getRequestAuthCode() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.codeUrlString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientId),
            URLQueryItem(name: "scope", value: Constants.scope)
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    private func getRequestAuthToken(with code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.tokenUrlString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientId),
            URLQueryItem(name: "client_secret", value: Constants.clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

//MARK: - NetworkManagerDelegate
/***************************************************************/

extension AuthManager: NetworkManagerDelegate {
    func processRequestResult(with status: NetworkResult) {
        switch status {
        case .failure(let error):
            fatalError(error)
        case .success:
            controller?.dismiss(animated: true, completion: nil)
            delegate?.authPassed()
        }
    }
}
