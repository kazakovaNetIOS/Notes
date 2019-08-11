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

protocol SaveNotesBackendDelegate {
    func process(result: SaveNotesBackendResult)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    
    var result: SaveNotesBackendResult?
    var loader: BackendDataLoader!
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
        loader = BackendDataLoader()
        loader.saveNotesDelegate = self
    }
    
    override func main() {
        checkGistId()
    }
}

//MARK: - BackendDataLoaderDelegate
/***************************************************************/

extension SaveNotesBackendOperation: SaveNotesBackendDelegate {
    func process(result: SaveNotesBackendResult) {
        self.result = result
        finish()
    }
}

//MARK: - Create gist
/***************************************************************/

extension SaveNotesBackendOperation {
    func insertGist() {
        guard let request = getPostRequest() else { return }
        
        loader.upload(with: request) { [weak self] (data, response) in
            guard let sself = self,
                let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                do {
                    let gistPostResponce = try JSONDecoder().decode(GistPostResponce.self, from: data)
                    BaseBackendOperation.gistId = gistPostResponce.id
                    sself.result = .success
                    DDLogDebug("Successfully created gist")
                } catch {
                    sself.result = .failure(.unreachable)
                    DDLogError("Error while parsing responce: \(error.localizedDescription)")
                }
            default:
                sself.result = .failure(.unreachable)
                print("Backend responce status: \(response.statusCode)")
            }
            
            sself.finish()
        }
    }
}

//MARK: - Update gist
/***************************************************************/

extension SaveNotesBackendOperation {
    func updateGist() {
        guard let request = getPatchRequest() else { return }
        
        loader.upload(with: request) { [weak self] (_, response) in
            guard let sself = self,
                let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                sself.result = .success
                DDLogDebug("Successfully updated gist")
            default:
                sself.result = .failure(.unreachable)
                print("Backend responce status: \(response.statusCode)")
            }
            
            sself.finish()
        }
    }
}

//MARK: - Check for gist existence
/***************************************************************/

extension SaveNotesBackendOperation {
    func checkGistId() {
        guard let url = URL(string: gistRepositoryUrl) else { return }
        
        loader.load(from: url) { [weak self] (data)  in
            guard let sself = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let listGists = try decoder.decode([Gist].self, from: data)
                BaseBackendOperation.gistId = listGists.getGistId(by: sself.gistFileName)
                
                if BaseBackendOperation.gistId == nil {
                    sself.insertGist()
                } else {
                    sself.updateGist()
                }
            } catch {
                DDLogError("Error while parsing list of gists: \(error)")
            }
        }
    }
}

//MARK: - Get data for upsert
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

//MARK: - Get PATCH request
/***************************************************************/

extension SaveNotesBackendOperation {
    func getPatchRequest() -> URLRequest? {
        guard let url = URL(string: gistPatchUrl) else { return nil }
        guard let encodedData = getData() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(BaseBackendOperation.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encodedData
        
        return request
    }
}

//MARK: - Get POST request
/***************************************************************/

extension SaveNotesBackendOperation {
    func getPostRequest() -> URLRequest? {
        guard let url = URL(string: gistPostUrl) else { return nil }
        guard let encodedData = getData() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(BaseBackendOperation.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encodedData
        
        return request
    }
}
