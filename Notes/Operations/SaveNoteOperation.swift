//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        self.note = note
        self.notebook = notebook
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook, backgroundContext: backgroundContext)
        saveToBackend = SaveNotesBackendOperation(notebook: notebook)
        
        super.init()
        
        saveToDb.completionBlock = { [weak self] in
            guard let sself = self else { return }

            backendQueue.addOperation(sself.saveToBackend)
        }
        
        addDependency(saveToDb)
        addDependency(saveToBackend)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        if let result = saveToBackend.result {
            switch result {
            case .success:
                self.result = true
            case .failure:
                self.result = false
            }
        }
        
        finish()
    }
}
