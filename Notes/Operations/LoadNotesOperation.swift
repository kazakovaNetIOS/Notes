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
    private var saveToDb: SaveNoteDBOperation?
    
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        loadFromDb = LoadNotesDBOperation(notebook: notebook,
                                          backgroundContext: backgroundContext)
        
        super.init()
        
        loadFromBackend.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            
            switch self.loadFromBackend.result! {
            case .success(let notes):
                self.saveToDb = SaveNoteDBOperation(notes: notes,
                                                    notebook: notebook,
                                                    backgroundContext: backgroundContext)
                self.saveToDb?.completionBlock = { [weak self] in
                    guard let `self` = self else { return }
                    
                    self.finish()
                }
                self.addDependency(self.saveToDb!)
                dbQueue.addOperation(self.saveToDb!)
                
                self.result = notes
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
