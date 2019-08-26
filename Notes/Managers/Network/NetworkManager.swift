//
//  NetworkManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 16/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate: class {
    func processRequestResult(with status: NetworkResult)
}

enum NetworkResult {
    case success
    case failure(String)
}

class NetworkManager {
    
    public static let shared = NetworkManager()
    public var delegate: NetworkManagerDelegate?
    
    private init() {}
}

//MARK: - Send request
/***************************************************************/

extension NetworkManager {
    public func sendRequest(with request: URLRequest, completion: @escaping (Data, URLResponse?) -> Void) {
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            
            guard error == nil else {
                self.delegate?.processRequestResult(with: .failure(error?.localizedDescription ?? "no description"))
                return
            }
            guard let data = data else {
                self.delegate?.processRequestResult(with: .failure("No data"))
                return
            }
            
            completion(data, response)
            
            self.delegate?.processRequestResult(with: .success)
            }.resume()
    }
}
