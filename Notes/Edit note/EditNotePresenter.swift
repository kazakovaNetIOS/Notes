//
//  EditNotePresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol EditNoteView: class {
    
}

protocol EditNotePresenterDelegate: class {
    func editNotePresenter(_ presenter: EditNotePresenter, didAdd note: Note)
    func editNotePresenterCancel(presenter: EditNotePresenter)
}

protocol EditNotePresenter {
    var router: EditNoteViewRouter { get }
    var titleForSaveButton: String { get }
    func saveButtonPressed(note: Note)
}

class EditNotePresenterImpl {
    
    private weak var view: EditNoteView?
    private(set) var router: EditNoteViewRouter
    private weak var delegate: EditNotePresenterDelegate?
    
    init(
        view: EditNoteView,
         router: EditNoteViewRouter,
         delegate: EditNotePresenterDelegate?) {
        self.view = view
        self.router = router
        self.delegate = delegate
    }
}

//MARK: - EditNotePresenter
/***************************************************************/

extension EditNotePresenterImpl: EditNotePresenter {
    var titleForSaveButton: String {
        return "Сохранить"
    }
    
    func saveButtonPressed(note: Note) {
        delegate?.editNotePresenter(self, didAdd: note)
    }
}
