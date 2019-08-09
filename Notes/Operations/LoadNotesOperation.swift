//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    
    private var loadFromBackend: LoadNotesBackendOperation
    private var loadFromDb: LoadNotesDBOperation
    
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        loadFromBackend.completionBlock = {
            switch self.loadFromBackend.result! {
            case .success(let notes):
                notebook.replaceAll(notes: notes)
                
                self.result = notes
            case .notFound:
                backendQueue.addOperation(self.loadFromDb)
            case .failure:
                self.result = []
            }
        }
        
        addDependency(loadFromBackend)
        addDependency(loadFromDb)
        
        dbQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        if let notes = loadFromDb.result {
            result = notes
        }
        
        finish()
    }
}
