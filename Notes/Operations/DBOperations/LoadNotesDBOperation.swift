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
    private let context: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    
    init(notebook: FileNotebook,
         mainContext: NSManagedObjectContext,
         backgroundContext: NSManagedObjectContext) {
        self.context = mainContext
        self.backgroundContext = backgroundContext
        
        super.init(notebook: notebook)
    }
    
    override func main() {
        fetchData()
        
        DDLogDebug("Load notes from db completed")
        
        finish()
    }
    
    func fetchData() {
        result = []
        let request = NSFetchRequest<MONote>(entityName: "MONote")
        
        let sortDescriptor = NSSortDescriptor(key: "uid", ascending: true)
        request.sortDescriptors = [sortDescriptor]
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
        } catch {
            print(error.localizedDescription)
        }
    }
}
