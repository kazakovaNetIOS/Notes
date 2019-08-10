//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    
    var result: SaveNotesBackendResult?
    var loader: BackendDataLoader!
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
        loader = BackendDataLoader()
        loader.delegate = self
    }
    
    override func main() {
        checkGistId()
    }
}

//MARK: - BackendDataLoaderDelegate
/***************************************************************/

extension SaveNotesBackendOperation: BackendDataLoaderDelegate {
    func process(result: LoadNotesBackendResult) {
        
    }
}

//MARK: - Upload
/***************************************************************/

extension SaveNotesBackendOperation {
    func upload() {
        guard let request = getPatchRequest() else { return }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    self.result = .success
                    print("Success")
                default:
                    self.result = .failure(.unreachable)
                    print("Backend responce status: \(response.statusCode)")
                }
                DDLogDebug("Save notes to backend result: \(String(describing: self.result))")
                self.finish()
            }
            }.resume()
    }
    
    func checkGistId() {
        guard let url = URL(string: gistRepositoryUrl) else { return }
        
        loader.load(from: url) { [weak self] (data) in
            guard let sself = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let listGists = try decoder.decode([Gist].self, from: data)
                BaseBackendOperation.gistId = listGists.getGistId(by: sself.gistFileName)
                
                if BaseBackendOperation.gistId == nil {
                    sself.createGist()
                } else {
                    sself.upload()
                }
            } catch {
                DDLogError("Error while parsing list of gists: \(error)")
            }
        }
    }
}

//MARK: - Create gist
/***************************************************************/

extension SaveNotesBackendOperation {
    func createGist() {
        guard let request = getPostRequest() else { return }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                //                sself.delegate.process(result: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                //                sself.delegate.process(result: .notFound)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                do {
                    let gistPostResponce = try JSONDecoder().decode(GistPostResponce.self, from: data)
                    BaseBackendOperation.gistId = gistPostResponce.id
                    DDLogDebug("Successfully created gist")
                } catch {
                    DDLogError("Error while parsing responce: \(error.localizedDescription)")
//                    sself.process(result: .notFound)
                }
            default:
//                self.result = .failure(.unreachable)
                print("Backend responce status: \(response.statusCode)")
            }
            DDLogDebug("Save notes to backend result: \(String(describing: sself.result))")
            sself.finish()
            }.resume()
    }
}

//MARK: - Get data
/***************************************************************/

extension SaveNotesBackendOperation {
    func getData() -> Data? {
        let file = GistFile(content: notebook.toJsonString())
        
        let gist = Gist(id: BaseBackendOperation.gistId ?? "",
                        description: gistFileName,
                        isPublic: true,
                        files: [gistFileName: file])
        
        return try? JSONEncoder().encode(gist)
    }
}

//MARK: - Get requests
/***************************************************************/

extension SaveNotesBackendOperation {
    func getPatchRequest() -> URLRequest? {
        guard let url = URL(string: gistPatchUrl) else { return nil }
        guard let encodedData = getData() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encodedData
        
        return request
    }
    
    func getPostRequest() -> URLRequest? {
        guard let url = URL(string: gistPostUrl) else { return nil }
        guard let encodedData = getData() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encodedData
        
        return request
    }
}

//Проверить сохранен ли айди гиста
//Если сохранен то обновить его содержимое
//Если не сохранен, то создать, залить данные и сохранить айди
