//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 31/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

class RemoveNoteOperation: AsyncOperation {
    
    private let noteId: String
    private var saveToBackend: SaveNotesBackendOperation
    private let removeFromDb: RemoveNoteDBOperation
    
    init(noteId: String,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        self.noteId = noteId
        
        removeFromDb = RemoveNoteDBOperation(noteId: noteId, notebook: notebook)
        saveToBackend = SaveNotesBackendOperation(notebook: notebook)
        
        super.init()
        
        removeFromDb.completionBlock = { [weak self] in
            guard let sself = self else { return }
            
            backendQueue.addOperation(sself.saveToBackend)
        }
        
        addDependency(removeFromDb)
        addDependency(saveToBackend)
        
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        DDLogDebug("Deleted note with ID \(noteId)")
        
        finish()
    }
}
