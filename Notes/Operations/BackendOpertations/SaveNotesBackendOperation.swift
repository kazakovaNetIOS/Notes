//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    
    var result: SaveNotesBackendResult?
    private let notes: [Note]
    
    init(notes: [Note]) {
        self.notes = notes
        super.init()
        GithubManager.shared.delegate = self
    }
    
    override func main() {
        guard let data = try? JSONEncoder().encode(FileNotebook.toGist(notes: notes)) else {
            finish()
            return
        }
        GithubManager.shared.upsert(data: data)
    }
}

//MARK: - GithubManagerDelegate
/***************************************************************/

extension SaveNotesBackendOperation: GithubManagerDelegate {
    func process(result: GithubManagerResult) {
        switch result {
        case .successLoad: break
        case .gistNotFound: break
        case .successUpsert: self.result = .success
        case .error(let error):
            print(error)
            self.result = .failure(.unreachable)
        }
//        self.result = .failure(.unreachable)
        finish()
    }
}
