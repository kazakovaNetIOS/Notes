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
    
    init(noteId: String,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.noteId = noteId
        super.init(notebook: notebook)
        CoreDataManager.shared.backgroundContext = backgroundContext
        CoreDataManager.shared.delegate = self
    }
    
    override func main() {
        CoreDataManager.shared.deleteNote(noteId: noteId)
    }
}

//MARK: - CoreDataManagerDelegate
/***************************************************************/

extension RemoveNoteDBOperation: CoreDataManagerDelegate {
    func process(result: CoreDataManagerResult) {
        switch result {
        case .successLoad:
            break
        case .error(let error):
            DDLogError(error)
        case .successDelete:
            break
        case .successSave:
            break
        }
        finish()
    }
}
