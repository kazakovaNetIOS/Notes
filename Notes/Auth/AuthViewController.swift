//
//  AuthViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 11/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import WebKit
import CocoaLumberjack

protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let webView = WKWebView()
    private let urlString = "https://api.github.com/authorizations"
    private let note = "NotesAppToken"
    private let clientId = "7aaddc81018489f6f650"
    private let clientSecret = "2180fd1eec8ff98450d5156ff0ddae588dc6aa05"
    private let scheme = "notes"
    private let callbackUrl = "https://kazakova-net.ru/login/callback"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        guard let request = codeGetRequest else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
}

//MARK: - Setup views
/***************************************************************/

extension AuthViewController {
    private func setupViews() {
        view.backgroundColor = .white
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}



//MARK: - Get token requests
/***************************************************************/

extension AuthViewController {
    func tokenPostRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/access_token") else {
            return nil
        }
        
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
    
    private var codeGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "scope", value: "gist")
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}

//MARK: - WKNavigationDelegate
/***************************************************************/

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
            url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                requestToken(with: code)
            }
            dismiss(animated: true, completion: nil)
        }
        defer {
            decisionHandler(.allow)
        }
    }
}

extension AuthViewController {
    func requestToken(with code: String) {
        guard let request = tokenPostRequest(code: code) else { return }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil,
                let data = data else {
                    DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                    return
            }
            
            guard let responseString = String(data: data, encoding: .utf8) else { return }
            let urlString = "https://github.com/?\(responseString)"
            guard let components = URLComponents(string: urlString) else { return }
            
            if let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value {
                sself.delegate?.handleTokenChanged(token: token)
            }
            }.resume()
        
        
    }
}
