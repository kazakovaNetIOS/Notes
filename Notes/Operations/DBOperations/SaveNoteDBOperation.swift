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
    
    init(note: Note,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.note = note
        super.init(notebook: notebook)
        CoreDataManager.shared.backgroundContext = backgroundContext
        CoreDataManager.shared.delegate = self
    }
    
    override func main() {
        CoreDataManager.shared.upsertNote(note: note)
    }
}

//MARK: - CoreDataManagerDelegate
/***************************************************************/

extension SaveNoteDBOperation: CoreDataManagerDelegate {
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
