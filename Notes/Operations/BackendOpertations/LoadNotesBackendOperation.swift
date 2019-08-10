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
    var loader: BackendDataLoader!
    
    private let gistRepositoryUrl = "https://api.github.com/users/kazakovaNetIOS/gists"
    private let gistFileName = "ios-course-notes-db"
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
        loader = BackendDataLoader(delegate: self)
    }
    
    override func main() {
        fetchListGists()
    }
}

//MARK: - text
/***************************************************************/

extension LoadNotesBackendOperation: BackendDataLoaderDelegate {
    func process(result: LoadNotesBackendResult) {
        self.result = result
        finish()
    }
}


//MARK: - Fetch data
/***************************************************************/

extension LoadNotesBackendOperation {
    private func fetchListGists() {
        guard let url = URL(string: gistRepositoryUrl) else { return }

        loader.load(from: url) { [weak self] (data) in
            guard let sself = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let listGists = try decoder.decode([Gist].self, from: data)
                sself.fetchNotebookData(from: listGists)
            } catch {
                DDLogError("Error while parsing list of gists: \(error)")
                sself.process(result: .notFound)
            }
        }
    }
    
    private func fetchNotebookData(from listGists: [Gist]) {
        guard let gistUrl = listGists.getGistUrl(by: gistFileName),
            let url = URL(string: gistUrl) else {
                process(result: .notFound)
                return
        }
        
        loader.load(from: url) { [weak self] (data) in
            guard let sself = self else { return }
            
            sself.notebook.parseNotes(from: data)
            DDLogDebug("Notes loaded from backend")
            sself.process(result: .success(sself.notebook.notes))
        }
    }
}
