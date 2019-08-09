//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success([Note])
    case notFound
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    
    var result: LoadNotesBackendResult?
    
    private let gistRepositoryUrl = "https://api.github.com/users/kazakovaNetIOS/gists"
    private let gistFileName = "ios-course-notes-db"
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        fetchListGists()
    }
    
    private func finishLoad(with result: LoadNotesBackendResult) {
        self.result = result
        finish()
    }
}

//MARK: - Fetch data
/***************************************************************/

extension LoadNotesBackendOperation {
    private func fetchListGists() {
        guard let url = URL(string: gistRepositoryUrl) else { return }
        
        load(from: url) { [weak self] (data) in
            guard let sself = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let listGists = try decoder.decode([Gist].self, from: data)
                sself.fetchNotebookData(from: listGists)
            } catch {
                DDLogError("Error while parsing list of gists: \(error)")
                sself.finishLoad(with: .notFound)
            }
        }
    }
    
    private func fetchNotebookData(from listGists: [Gist]) {
        guard let gistUrl = listGists.getGistUrl(by: gistFileName),
            let url = URL(string: gistUrl) else {
                finishLoad(with: .notFound)
                return
        }
        
        load(from: url) { [weak self] (data) in
            guard let sself = self else { return }
            
            let notes = sself.notebook.getNotes(from: data)
            DDLogDebug("Notes loaded from backend")
            sself.finishLoad(with: .success(notes))            
        }
    }
}

//MARK: - Load function
/***************************************************************/

extension LoadNotesBackendOperation {
    private func load(from url: URL, completion: @escaping (_ data: Data) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.finishLoad(with: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.finishLoad(with: .notFound)
                return
            }
            
            completion(data)
            }.resume()
    }
}
