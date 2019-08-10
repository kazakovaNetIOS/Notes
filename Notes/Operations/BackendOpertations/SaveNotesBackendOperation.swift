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
    
    override func main() {
        upload()
    }
}

//MARK: - Upload
/***************************************************************/

extension SaveNotesBackendOperation {
    func upload() {
        guard let request = getRequest() else { return }
        
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
}

//MARK: - Helper functions
/***************************************************************/

extension SaveNotesBackendOperation {
    func getRequest() -> URLRequest? {
        guard let url = URL(string: gistPatchUrl) else { return nil }
        guard let encodedData = getData() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encodedData
        
        return request
    }

    func getData() -> Data? {
        let file = GistFile(content: notebook.toJsonString())
        
        let gist = Gist(description: gistFileName,
                        isPublic: true,
                        files: [gistFileName: file])
        
        return try? JSONEncoder().encode(gist)
    }
}
