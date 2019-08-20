//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CoreData

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let noteId: String
    private let backgroundContext: NSManagedObjectContext
    
    init(noteId: String,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.noteId = noteId
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        deleteData()
        finish()
    }
}

//MARK: - Delete data
/***************************************************************/

extension RemoveNoteDBOperation {
    private func deleteData() {
        backgroundContext.performAndWait {
            let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", noteId)
            
            do {
                let fetchedObjects = try backgroundContext.fetch(request)
                backgroundContext.delete(fetchedObjects[0])
                
                try backgroundContext.save()
                
                DDLogDebug("Remove note from db completed")
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }
}
