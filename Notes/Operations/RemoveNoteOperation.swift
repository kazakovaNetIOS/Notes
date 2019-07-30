//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 31/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    
    private var saveToBackend: SaveNotesBackendOperation?
    private let removeFromDb: RemoveNoteDBOperation
    
    init(noteId: String,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        notebook.remove(with: noteId)
        
        removeFromDb = RemoveNoteDBOperation(noteId: noteId, notebook: notebook)
        
        super.init()
        
        removeFromDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
            backendQueue.addOperation(saveToBackend)
        }
        
        addDependency(removeFromDb)
        dbQueue.addOperation(removeFromDb)
    }
}
