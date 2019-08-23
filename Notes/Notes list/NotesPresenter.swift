//
//  NotesPresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol NotesView: class {
    func switchEditingModeOff()
    func switchEditingModeOn()
    func refreshNotesView()
    func deleteAnimated(at index: IndexPath)
    func disableListEditing()
    func enableListEditing()
    func show(authController: AuthControllerProtocol)
}

protocol NoteCellView {
    func display(note: Note)
}

protocol NotesPresenter: class {
    var numberOfNotes: Int { get }
    var router: NotesViewRouter { get }
    var titleForEditButton: String { get }
    var titleForDoneButton: String { get }
    
    func didTapEditButton()
    func didTapAddButton()
    func didSelect(row: Int)
    func viewDidLoad()
    func didEndEdit(note: Note)
    func configure(cell: NoteCellView, forRow row: Int)
    func deleteButtonPressed(at index: IndexPath)
    
    init(manager: NotesManager, view: NotesView, router: NotesViewRouter)
}

class NotesListPresenterImplementation {
    
    private let manager: NotesManager
    private weak var view: NotesView?
    private var isEditing = false
    private var first = true
    let router: NotesViewRouter
    
    required init(manager: NotesManager,
                  view: NotesView,
                  router: NotesViewRouter) {
        self.view = view
        self.router = router
        self.manager = manager
        self.manager.delegate = self
    }
}

//MARK: - NotesManagerDelegate
/***************************************************************/

extension NotesListPresenterImplementation: NotesManagerDelegate {
    func notesManagerDidLoadNotes(_ manager: NotesManager) {
        self.view?.refreshNotesView()
    }
    
    func requestAuth(with controller: AuthControllerProtocol) {
        view?.show(authController: controller)
    }
}

//MARK: - NotesPresenter
/***************************************************************/

extension NotesListPresenterImplementation: NotesPresenter {
    var titleForEditButton: String { return "Edit" }
    var titleForDoneButton: String { return "Done" }
    var numberOfNotes: Int { return manager.notes.count }
    
    func configure(cell: NoteCellView, forRow row: Int) { cell.display(note: manager.notes[row]) }
    
    func note(at index: Int) -> Note { return manager.notes[index] }
    
    func didTapAddButton() { router.presentEditNote(for: manager.newNote()) }
    
    func didSelect(row: Int) { router.presentEditNote(for: manager.notes[row]) }
    
    func didEndEdit(note: Note) {
        view?.disableListEditing()
        manager.save(note) { [weak self] in
            guard let `self` = self else { return }
            self.view?.enableListEditing()
            self.view?.refreshNotesView()
        }
    }
    
    func deleteButtonPressed(at index: IndexPath) {
        manager.delete(at: index.row) { [weak self] in
            guard let `self` = self else { return }
            self.view?.deleteAnimated(at: index)
        }
    }
    
    func viewDidLoad() {
        guard first else { return }
        manager.load()
        first = false
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
