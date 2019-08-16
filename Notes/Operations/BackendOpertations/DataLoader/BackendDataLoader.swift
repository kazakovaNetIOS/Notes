//
//  BackendDataLoader.swift
//  Notes
//
//  Created by Natalia Kazakova on 10/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol BackendDataLoaderProtocol {
    func load(from url: URL, completion: @escaping (_ data: Data) -> Void)
    func upload(with url: URLRequest, completion: @escaping (_ data: Data, _ responce: URLResponse?) -> Void)
}

class BackendDataLoader {
    
    var loadNotesDelegate: LoadNotesBackendDelegate?
    var saveNotesDelegate: SaveNotesBackendDelegate?
    
    var gistPatchUrl: String {
        return "\(gistRepositoryUrl)/\(BaseBackendOperation.gistId!)"
    }
    let gistRepositoryUrl = "https://api.github.com/gists"
}

//MARK: - BackendDataLoaderProtocol
/***************************************************************/

extension BackendDataLoader: BackendDataLoaderProtocol {
    func upload(with request: URLRequest, completion: @escaping (Data, URLResponse?) -> Void) {
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.saveNotesDelegate?.process(result: .failure(.unreachable))
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.saveNotesDelegate?.process(result: .failure(.unreachable))
                return
            }
            
            completion(data, response)
            }.resume()
    }
    
    func load(from url: URL, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.loadNotesDelegate?.process(result: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.loadNotesDelegate?.process(result: .notFound)
                return
            }
            
            completion(data)
            }.resume()
    }
}

//MARK: - Get PATCH request
/***************************************************************/

extension BackendDataLoader {
    func getPatchRequest(with data: Data) -> URLRequest? {
        guard let url = URL(string: gistPatchUrl) else { return nil }
        
        guard let token = AuthManager.shared.token else {
            saveNotesDelegate?.process(result: .failure(.unreachable))
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = data
        
        return request
    }
}

//MARK: - Get POST request
/***************************************************************/

extension BackendDataLoader {
    func getPostRequest(with data: Data) -> URLRequest? {
        guard let url = URL(string: gistRepositoryUrl) else { return nil }
        
        guard let token = AuthManager.shared.token else {
            saveNotesDelegate?.process(result: .failure(.unreachable))
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = data
        
        return request
    }
}

//MARK: - Get request with token
/***************************************************************/

extension BackendDataLoader {
    func getRequestWithToken() -> URLRequest? {
        guard let url = URL(string: gistRepositoryUrl) else { return nil }
        
        guard let token = AuthManager.shared.token else {
            saveNotesDelegate?.process(result: .failure(.unreachable))
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
