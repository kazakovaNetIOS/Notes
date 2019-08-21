//
//  GithubManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 19/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol GithubManagerDelegate {
    func process(result: GithubManagerResult)
}

enum GithubManagerResult {
    case successLoad(Data)
    case gistNotFound
    case successUpsert
    case error(String)
}

class GithubManager {
    
    public static let shared = GithubManager()
    public var delegate: GithubManagerDelegate?
    public var gistId: String?
    
    private var gistPatchUrl: String {
        return "\(Constants.gistRepositoryUrl)/\(gistId!)"
    }
    
    private init() {
        NetworkManager.shared.delegate = self
    }
}

//MARK: - Constants
/***************************************************************/

extension GithubManager {
     enum Constants {
         static let gistRepositoryUrl = "https://api.github.com/gists"
         static let gistFileName = "ios-course-notes-db"
    }
}

//MARK: - Public
/***************************************************************/

extension GithubManager {
    public func fetchGistsData() {
        fetchGistList { [weak self] (listGists) in
            guard let `self` = self else { return }
            
            self.fetchNotebookData(from: listGists)
        }
    }
    
    public func upsert(data: Data) {
        fetchGistList { [weak self] (listGists) in
            guard let `self` = self else { return }
            
            self.gistId = listGists.getGistId(by: Constants.gistFileName)
            
            if self.gistId == nil {
                self.insert(data: data)
            } else {
                self.update(data: data)
            }
        }
    }
}

//MARK: - Fetch data
/***************************************************************/

extension GithubManager {
    private func fetchNotebookData(from listGists: [Gist]) {
        guard let gistUrl = listGists.getGistUrl(by: Constants.gistFileName),
            let url = URL(string: gistUrl) else {
                self.delegate?.process(result: .gistNotFound)
                return
        }
        
        NetworkManager.shared.sendRequest(with: URLRequest(url: url)) { [weak self] (data, _) in
            guard let `self` = self else { return }
            self.delegate?.process(result: .successLoad(data))
        }
    }
    
    private func fetchGistList(completion: @escaping ([Gist]) -> Void) {
        guard let request = getRequestWithToken() else { return }
        
        NetworkManager.shared.sendRequest(with: request) { (data, _) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            guard let listGists = try? decoder.decode([Gist].self, from: data) else {
                fatalError()
            }
            completion(listGists)
        }
    }
}

//MARK: - Create gist
/***************************************************************/

extension GithubManager {
    func insert(data: Data) {
        guard let request = getRequest(with: data, method: "POST") else { return }
        
        NetworkManager.shared.sendRequest(with: request) { [weak self] (data, response) in
            guard let `self` = self,
                let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                do {
                    let gistPostResponce = try JSONDecoder().decode(GistPostResponce.self, from: data)
                    self.gistId = gistPostResponce.id
                    self.delegate?.process(result: .successUpsert)
                } catch {
                    self.delegate?.process(result: .error("Error while parsing responce: \(error.localizedDescription)"))
                }
            default:
                self.delegate?.process(result: .error("Backend responce status: \(response.statusCode)"))
            }
        }
    }
}

//MARK: - Update gist
/***************************************************************/

extension GithubManager {
    func update(data: Data) {
        guard let request = getRequest(with: data, method: "PATCH") else { return }
        
        NetworkManager.shared.sendRequest(with: request) { [weak self] (_, response) in
            guard let `self` = self,
                let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                self.delegate?.process(result: .successUpsert)
            default:
                self.delegate?.process(result: .error("Backend responce status: \(response.statusCode)"))
            }
        }
    }
}

//MARK: - Get requests
/***************************************************************/

extension GithubManager {
    private func getRequest(with data: Data, method: String?) -> URLRequest? {
        var urlString = Constants.gistRepositoryUrl
        if method == "PATCH" {
            urlString = gistPatchUrl
        }
        
        guard var request = getRequestWithToken(urlString: urlString) else { return nil }
        request.httpMethod = method
        request.httpBody = data
        return request
    }
    
    private func getRequestWithToken(urlString: String = Constants.gistRepositoryUrl) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        guard let token = AuthManager.shared.token else {
            fatalError("Token not found")
        }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

//MARK: - NetworkManagerDelegate
/***************************************************************/

extension GithubManager: NetworkManagerDelegate {
    func processRequestResult(with status: NetworkResult) {
        switch status {
        case .success: break
        case .failure(let error):
            self.delegate?.process(result: .error(error))
            break
        }
    }
}
