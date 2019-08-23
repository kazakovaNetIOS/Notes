//
//  NotesManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CoreData

protocol NotesManagerDelegate {
    func requestAuth(with controller: AuthControllerProtocol)
    func notesManagerDidLoadNotes(_ manager: NotesManager)
}

class NotesManager {
    
    public var delegate: NotesManagerDelegate?
    private var context: NSManagedObjectContext
    
    public private(set) var notes: [Note] = [] {
        didSet {
            notes.sort(by: { $0.title < $1.title })
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        AuthManager.shared.delegate = self
    }
}

//MARK: - Public API
/***************************************************************/
extension NotesManager {
    public func load() {
        AuthManager.shared.authCheck()
    }
    
    public func delete(at index: Int, completion: @escaping () -> Void) {
        let removeNote = RemoveNoteOperation(notes: notes,
                                             backendQueue: OperationQueue(),
                                             dbQueue: OperationQueue(),
                                             backgroundContext: context)
        removeNote.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            self.notes.remove(at: index)
            OperationQueue.main.addOperation {
                completion()
            }
        }
        OperationQueue().addOperation(removeNote)
    }
    
    public func save(_ note: Note, completion: @escaping () -> Void) {
        notes.replace(note)
        
        let saveNoteOperation = SaveNoteOperation(notes: notes,
                                                  backendQueue: OperationQueue(),
                                                  dbQueue: OperationQueue(),
                                                  backgroundContext: context)
        saveNoteOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion()
            }
        }
        OperationQueue().addOperation(saveNoteOperation)
    }
    
    public func newNote() -> Note{
        return Note(title: "", content: "", importance: .ordinary, dateOfSelfDestruction: nil)
    }
}

//MARK: - AuthManagerDelegate
/***************************************************************/

extension NotesManager: AuthManagerDelegate {
    func authPassed() {
        let loadNotes = LoadNotesOperation(backendQueue: OperationQueue(),
                                           dbQueue: OperationQueue(),
                                           backgroundContext: context)
        loadNotes.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            self.notes = loadNotes.result ?? []
            OperationQueue.main.addOperation {
                self.delegate?.notesManagerDidLoadNotes(self)
            }
        }
        OperationQueue().addOperation(loadNotes)
    }
    
    func show(_ authController: AuthControllerProtocol) {
        delegate?.requestAuth(with: authController)
    }
}
