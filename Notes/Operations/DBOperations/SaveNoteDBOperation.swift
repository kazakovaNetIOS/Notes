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
//        notebook.add(note: note)
//        notebook.saveToFile()
        
        addNote()
        
        DDLogDebug("Save notes to db completed")
    }

    func addNote() {
        let moNote = MONote(context: self.backgroundContext)
        moNote.uid = note.uid
        moNote.title = note.title
        moNote.content = note.content
        moNote.color = note.color
        moNote.importance = note.importance.rawValue
        moNote.dateOfSelfDestruction = note.dateOfSelfDestruction
        
        self.backgroundContext.performAndWait {
            do {
                try self.backgroundContext.save()
                finish()
            } catch {
                print(error)
            }
        }
    }
}

