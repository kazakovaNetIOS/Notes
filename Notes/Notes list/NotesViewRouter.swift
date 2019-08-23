//
//  NotesViewRouter.swift
//  Notes
//
//  Created by Natalia Kazakova on 23/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol NotesViewRouter {
    func presentEditNote(for note: Note)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class NotesViewRouterImplementation {
    
    fileprivate weak var notesViewController: NotesViewController?
    fileprivate var note: Note!
    
    init(notesViewController: NotesViewController) {
        self.notesViewController = notesViewController
    }
}

//MARK: - NotesViewRouter
/***************************************************************/

extension NotesViewRouterImplementation: NotesViewRouter {
    func presentEditNote(for note: Note) {
        self.note = note
        notesViewController?.performSegue(withIdentifier: "goToEditNote", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
        let editNoteVC = segue.destination as? EditNoteController {
            editNoteVC.note = note
            //TODO: - FIX
            /***************************************************************/
            editNoteVC.delegate = notesViewController
        }
    }
}
