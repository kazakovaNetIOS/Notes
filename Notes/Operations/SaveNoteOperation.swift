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
    
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation
    
    private(set) var result: Bool? = false
    
    init(notes: [Note],
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        saveToDb = SaveNoteDBOperation(notes: notes, backgroundContext: backgroundContext)
        saveToBackend = SaveNotesBackendOperation(notes: notes)
        
        super.init()
        
        saveToDb.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            
            backendQueue.addOperation(self.saveToBackend)
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
