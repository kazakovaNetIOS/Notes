//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case notFound
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    
    var result: LoadNotesBackendResult?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
        GithubManager.shared.delegate = self
    }
    
    override func main() {
        GithubManager.shared.fetchGistsData()
    }
}

//MARK: - GithubManagerDelegate
/***************************************************************/

extension LoadNotesBackendOperation: GithubManagerDelegate {
    func process(result: GithubManagerResult) {
        switch result {
        case .successLoad(let data):
            guard let notes = try? FileNotebook.parseNotes(from: data) else {
                self.result = .failure(.unreachable)
                break
            }
            self.result = .success(notes)
        case .gistNotFound:
            self.result = .notFound
        case .successUpsert: break
        case .error(_):
            self.result = .failure(.unreachable)
        }
//        self.result = .notFound
        finish()
    }
}
