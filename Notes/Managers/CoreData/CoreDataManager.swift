//
//  CoreDataManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 20/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData


protocol CoreDataManagerDelegate {
    func process(result: CoreDataManagerResult)
}

enum CoreDataManagerResult {
    case successLoad([Note])
    case successDelete
    case successSave
    case error(String)
}

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    public var delegate: CoreDataManagerDelegate?
    public var backgroundContext: NSManagedObjectContext!
    
    private init() {
    }
}

//MARK: - Fetch notes
/***************************************************************/

extension CoreDataManager {
    func fetchNotes() {
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        
        backgroundContext.performAndWait {
            do {
                let moNotes: [NoteMO] = try backgroundContext.fetch(request)
                var result = [Note]()
                
                for moNote in moNotes {
                    result.append(Note(uid: moNote.uid ?? UUID().uuidString,
                                        title: moNote.title ?? "",
                                        content: moNote.content ?? "",
                                        color: moNote.color as? UIColor ?? UIColor.white,
                                        importance: Importance(rawValue: moNote.importance ?? Importance.ordinary.rawValue) ?? Importance.ordinary,
                                        dateOfSelfDestruction: moNote.dateOfSelfDestruction))
                }
                
                delegate?.process(result: .successLoad(result))
            } catch {
                delegate?.process(result: .error(error.localizedDescription))
            }
        }
    }
}

//MARK: - Delete note
/***************************************************************/

extension CoreDataManager {
    public func delete(notes: [Note]) {
        backgroundContext.performAndWait {
            let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
            request.predicate = NSPredicate(format: "uid in %@", notes.compactMap{ $0.uid })
            
            do {
                let fetchedObjects = try backgroundContext.fetch(request)
                try deleteList(fetchedObjects)
                
                delegate?.process(result: .successDelete)
            } catch {
                delegate?.process(result: .error(error.localizedDescription))
            }
        }
    }
    
    private func deleteList(_ fetchedObjects: [NoteMO]) throws {
        for object in fetchedObjects {
            backgroundContext.delete(object)
            try backgroundContext.save()
        }
    }
}

//MARK: - Upsert note
/***************************************************************/

extension CoreDataManager {
    public func upsertNote(note: Note) {
        backgroundContext.performAndWait {
            let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", note.uid)
            
            do {
                let fetchedObjects = try backgroundContext.fetch(request)
                
                if fetchedObjects.count > 0 {
                    setValues(fetchedObjects[0], with: note)
                } else {
                    setValues(NoteMO(context: backgroundContext), with: note)
                }
                try backgroundContext.save()
                delegate?.process(result: .successSave)
            } catch {
                delegate?.process(result: .error(error.localizedDescription))
            }
        }
    }
}

//MARK: - Set values by NoteMO object
/***************************************************************/

extension CoreDataManager {
    private func setValues(_ moNote: NoteMO, with note: Note) {
        moNote.uid = note.uid
        moNote.title = note.title
        moNote.content = note.content
        moNote.color = note.color
        moNote.importance = note.importance.rawValue
        moNote.dateOfSelfDestruction = note.dateOfSelfDestruction
    }
}

//MARK: - Save all notes
/***************************************************************/

extension CoreDataManager {
    public func saveAll(notes: [Note]) {
        backgroundContext.performAndWait {
            let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
            
            do {
                let fetchedObjects = try backgroundContext.fetch(request)
                try deleteList(fetchedObjects)
                
                for note in notes {
                    setValues(NoteMO(context: backgroundContext), with: note)
                    try backgroundContext.save()
                }
                
                delegate?.process(result: .successSave)
            } catch {
                delegate?.process(result: .error(error.localizedDescription))
            }
        }
    }
}
