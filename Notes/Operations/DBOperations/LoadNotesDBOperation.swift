//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CoreData

class LoadNotesDBOperation: BaseDBOperation {
    
    var result: [Note]?
    private let backgroundContext: NSManagedObjectContext
    
    init(notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        fetchData()
        finish()
    }
}

//MARK: - Fetch data
/***************************************************************/

extension LoadNotesDBOperation {
    func fetchData() {
        result = []
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let request: NSFetchRequest<MONote> = MONote.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        
        backgroundContext.performAndWait {
            do {
                let moNotes: [MONote] = try backgroundContext.fetch(request)
                
                for moNote in moNotes {
                    result?.append(Note(uid: moNote.uid ?? UUID().uuidString,
                                        title: moNote.title ?? "",
                                        content: moNote.content ?? "",
                                        color: moNote.color as? UIColor ?? UIColor.white,
                                        importance: Importance(rawValue: moNote.importance ?? Importance.ordinary.rawValue) ?? Importance.ordinary,
                                        dateOfSelfDestruction: moNote.dateOfSelfDestruction))
                }
                
                DDLogDebug("Load notes from db completed")
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }
}
