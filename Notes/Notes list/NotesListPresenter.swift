//
//  NotesListPresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol NotesListPresenterProtocol: class {
    func didTapEditButton()
    func didTapAddButton()
    func didViewLoad()
    func didEndEdit(note: Note)
    func numberOfNotes() -> Int
    func note(at index: Int) -> Note
    func didSwipeLeftRow(at index: IndexPath)
    init(manager: NotesManager, view: NotesListViewProtocol)
}

class NotesListPresenter {
    
    private let manager: NotesManager
    weak private var view: NotesListViewProtocol?
    private var isEditing = false
    private var first = true
    
    required init(manager: NotesManager, view: NotesListViewProtocol) {
        self.manager = manager
        self.view = view
        self.manager.delegate = self
    }
}

//MARK: - NotesManagerDelegate
/***************************************************************/

extension NotesListPresenter: NotesManagerDelegate {
    func notesManagerDidLoadNotes(_ manager: NotesManager) {
        self.view?.showNoteList()
    }
    
    func requestAuth(with controller: AuthControllerProtocol) {
        view?.show(authController: controller)
    }
}

//MARK: - NotesListPresenterProtocol
/***************************************************************/

extension NotesListPresenter: NotesListPresenterProtocol {
    func didEndEdit(note: Note) {
        view?.disableListEditing()
        manager.save(note) { [weak self] in
            guard let `self` = self else { return }
            self.view?.enableListEditing()
            self.view?.showNoteList()
        }
    }
    
    func didSwipeLeftRow(at index: IndexPath) {
        manager.delete(at: index.row) { [weak self] in
            guard let `self` = self else { return }
            self.view?.showDeletingNote(at: index)
        }
    }
    
    func note(at index: Int) -> Note {
        return manager.notes[index]
    }
    
    func numberOfNotes() -> Int {
        return manager.notes.count
    }
    
    func didViewLoad() {
        guard first else { return }
        manager.load()
        first = false
    }
    
    func didTapAddButton() {
        view?.goToEditScreen(editedNote: manager.newNote())
    }
    
    func didTapEditButton() {
        if(isEditing == true) {
            view?.switchEditingModeOff()
        } else {
            view?.switchEditingModeOn()
        }
        
        isEditing = !isEditing
    }    
}
