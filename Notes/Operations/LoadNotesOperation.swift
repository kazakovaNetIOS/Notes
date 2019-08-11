//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

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
                self.result = notes
                self.finish()
            case .notFound:
                dbQueue.addOperation(self.loadFromDb)
            case .failure:
                self.result = []
                self.finish()
            }
        }
        
        addDependency(loadFromBackend)
        addDependency(loadFromDb)
        
        backendQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        if let notes = loadFromDb.result {
            result = notes
        }
        
        finish()
    }
}
