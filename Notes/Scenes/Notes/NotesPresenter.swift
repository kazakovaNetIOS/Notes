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
}

protocol NoteCellView {
    func display(note: Note)
}

protocol NotesPresenter: class {
    var numberOfNotes: Int { get }
    var titleForEditButton: String { get }
    var titleForDoneButton: String { get }
    
    func didTapEditButton()
    func didTapAddButton()
    func didSelect(row: Int)
    func configure(cell: NoteCellView, forRow row: Int)
    func deleteButtonPressed(at index: IndexPath)
    func passButtonTapped()
    func didLoadNotes()
    func viewWillAppear()
    
    init(manager: NotesManager, view: NotesView)
}

protocol NotesPresenterDelegate {
    func notesPresenterDidAddOrEditNote(_ note: Note)
    func notesPresentDidPasswordButtonTapped()
}

class NotesPresenterImpl {
    
    private let manager: NotesManager
    private weak var view: NotesView?
    private var isEditing = false
    var delegate: NotesPresenterDelegate?
    
    required init(manager: NotesManager,
                  view: NotesView) {
        self.view = view
        self.manager = manager
        self.view?.disableListEditing()
    }
}

//MARK: - NotesPresenter
/***************************************************************/

extension NotesPresenterImpl: NotesPresenter {
    func viewWillAppear() {
        view?.enableListEditing()
        view?.refreshNotesView()
    }
    
    func didLoadNotes() {
        view?.enableListEditing()
        view?.refreshNotesView()
    }
    
    func passButtonTapped() { delegate?.notesPresentDidPasswordButtonTapped() }
    
    var titleForEditButton: String { return "Edit" }
    var titleForDoneButton: String { return "Done" }
    var numberOfNotes: Int { return manager.notes.count }
    
    func configure(cell: NoteCellView, forRow row: Int) { cell.display(note: manager.notes[row]) }
    
    func note(at index: Int) -> Note { return manager.notes[index] }
    
    func didTapAddButton() { delegate?.notesPresenterDidAddOrEditNote(manager.newNote()) }
    
    func didSelect(row: Int) { delegate?.notesPresenterDidAddOrEditNote(manager.notes[row]) }
    
    func deleteButtonPressed(at index: IndexPath) {
        manager.delete(at: index.row) { [weak self] in
            guard let `self` = self else { return }
            self.view?.deleteAnimated(at: index)
        }
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
