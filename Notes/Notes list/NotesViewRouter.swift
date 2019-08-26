//
//  NotesViewRouter.swift
//  Notes
//
//  Created by Natalia Kazakova on 23/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol NotesViewRouter: class {
    func presentEditNote(for note: Note, editNotePresenterDelegate: EditNotePresenterDelegate)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class NotesViewRouterImpl {
    
    private weak var notesViewController: NotesViewController?
    private weak var editNotePresenterDelegate: EditNotePresenterDelegate?
    private var note: Note!
    
    init(notesViewController: NotesViewController) {
        self.notesViewController = notesViewController
    }
}

//MARK: - NotesViewRouter
/***************************************************************/

extension NotesViewRouterImpl: NotesViewRouter {
    func presentEditNote(for note: Note, editNotePresenterDelegate: EditNotePresenterDelegate) {
        self.editNotePresenterDelegate = editNotePresenterDelegate
        self.note = note
        notesViewController?.performSegue(withIdentifier: "goToEditNote", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
            let editNoteVC = segue.destination as? EditNoteViewController {
            editNoteVC.configurator = EditNoteConfiguratorImpl(note: note,
                                                               editNotePresenterDelegate: editNotePresenterDelegate)
        }
    }
}
