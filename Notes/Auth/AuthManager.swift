//
//  AuthManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 16/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import WebKit

protocol AuthManagerDelegate {
    func show(_ authController: UIViewController)
    func authPassed()
}

class AuthManager {
    
    public static let shared = AuthManager()
    public var delegate: AuthManagerDelegate?
    private var controller: AuthViewController?
    
    private let tokenKey = "token"
    private let clientId = "7aaddc81018489f6f650"
    private let clientSecret = "2180fd1eec8ff98450d5156ff0ddae588dc6aa05"
    private let scheme = "notes"
    private let scope = "gist"
    private let tokenUrlString = "https://github.com/login/oauth/access_token"
    private let codeUrlString = "https://github.com/login/oauth/authorize"
    private let gitHubDomain = "https://github.com/"
    
    public private(set) var token: String? {
        get { return UserDefaults.standard.object(forKey: tokenKey) as? String }
        set { UserDefaults.standard.set(token, forKey: tokenKey) }
    }
    
    private init() {}
}

//MARK: - Public
/***************************************************************/

extension AuthManager {
    public func authCheck() {
        if token != nil { delegate?.authPassed() }
        else { showAuthController() }
    }
    
    public func process(_ navigationAction: WKNavigationAction,
                        _ decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
            url.scheme == scheme {
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
    
    private func getRequestAuthCode() -> URLRequest? {
        guard var urlComponents = URLComponents(string: codeUrlString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "scope", value: scope)
        ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    private func requestToken(with code: String) {
        guard let request = getRequestAuthToken(with: code) else { return }
        
        NetworkManager.shared.delegate = self
        NetworkManager.shared.sendRequest(with: request) { [weak self] (data, _) in
            guard let `self` = self else { return }
            guard let responseString = String(data: data, encoding: .utf8) else { return }
            
            let components = URLComponents(string: "\(self.gitHubDomain)?\(responseString)")
            self.token = components?.queryItems?.first(where: { $0.name == "access_token" })?.value
        }
    }
    
    private func getRequestAuthToken(with code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: tokenUrlString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

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
