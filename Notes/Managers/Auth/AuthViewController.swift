//
//  AuthViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 11/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import WebKit

protocol AuthControllerProtocol {
    
}

final class AuthViewController: UIViewController {
    
    private let webView = WKWebView()
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - AuthControllerProtocol
/***************************************************************/

extension AuthViewController: AuthControllerProtocol {
    
}

//MARK: - Override methods
/***************************************************************/

extension AuthViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        webView.load(request)
        webView.navigationDelegate = self
    }
}

//MARK: - Setup views
/***************************************************************/

extension AuthViewController {
    private func setupViews() {
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

//MARK: - WKNavigationDelegate
/***************************************************************/

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        AuthManager.shared.process(navigationAction, decisionHandler)
    }
}
