//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 31/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//
import Foundation
import CocoaLumberjack
import CoreData

class RemoveNoteOperation: AsyncOperation {
    
    private let notes: [Note]
    private var saveToBackend: SaveNotesBackendOperation
    private let removeFromDb: RemoveNoteDBOperation
    
    init(notes: [Note],
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        self.notes = notes
        
        removeFromDb = RemoveNoteDBOperation(notes: notes, notebook: notebook, backgroundContext: backgroundContext)
        saveToBackend = SaveNotesBackendOperation(notes: notes, notebook: notebook)
        
        super.init()
        
        removeFromDb.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            
            backendQueue.addOperation(self.saveToBackend)
        }
        
        addDependency(removeFromDb)
        addDependency(saveToBackend)
        
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {        
        finish()
    }
}
