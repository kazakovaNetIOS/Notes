//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CoreData

class SaveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    private let backgroundContext: NSManagedObjectContext
    
    init(note: Note,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.note = note
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        upsertData()
        finish()
    }
}


//MARK: - Upsert data
/***************************************************************/

extension SaveNoteDBOperation {
    private func upsertData() {
        backgroundContext.performAndWait {
            let request: NSFetchRequest<MONote> = MONote.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", note.uid)
            
            do {
                let fetchedObjects = try backgroundContext.fetch(request)
                
                if fetchedObjects.count > 0 {
                    try updateData(for: fetchedObjects[0])
                } else {
                    try insertData()
                }
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }
}

//MARK: - Update data
/***************************************************************/

extension SaveNoteDBOperation {
    private func updateData(for moNote: MONote) throws {
        setValues(moNote)
        
        try backgroundContext.save()
        
        DDLogDebug("Update note in db completed")
    }
}

//MARK: - Insert data
/***************************************************************/

extension SaveNoteDBOperation {
    private func insertData() throws {
        setValues(MONote(context: backgroundContext))
        
        try backgroundContext.save()
        
        DDLogDebug("Insert note to db completed")
    }
}

//MARK: - Set values by MONote object
/***************************************************************/

extension SaveNoteDBOperation {
    private func setValues(_ moNote: MONote) {
        moNote.uid = note.uid
        moNote.title = note.title
        moNote.content = note.content
        moNote.color = note.color
        moNote.importance = note.importance.rawValue
        moNote.dateOfSelfDestruction = note.dateOfSelfDestruction
    }
}
