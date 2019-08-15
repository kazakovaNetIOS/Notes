//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CoreData

class LoadNotesOperation: AsyncOperation {
    
    private var loadFromBackend: LoadNotesBackendOperation
    private var loadFromDb: LoadNotesDBOperation
    
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         mainContext: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext) {
        
        loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        loadFromDb = LoadNotesDBOperation(notebook: notebook,
                                          backgroundContext: backgroundContext)
        
        super.init()
        
        loadFromBackend.completionBlock = { [weak self] in
            guard let sself = self else { return }
            
            switch sself.loadFromBackend.result! {
            case .success(let notes):
                sself.result = notes
                sself.finish()
            case .notFound:
                dbQueue.addOperation(sself.loadFromDb)
            case .failure:
                sself.result = []
                sself.finish()
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
