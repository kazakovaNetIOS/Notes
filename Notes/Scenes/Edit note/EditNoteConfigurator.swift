//
//  EditNoteConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol EditNoteConfigurator {
    func configure(editNoteViewController: EditNoteViewController)
    init(note: Note, editNotePresenterDelegate: EditNotePresenterDelegate?)
}

class EditNoteConfiguratorImpl {
    
    var note: Note
    var editNotePresenterDelegate: EditNotePresenterDelegate?
    
    required init(note: Note, editNotePresenterDelegate: EditNotePresenterDelegate?) {
        self.note = note
        self.editNotePresenterDelegate = editNotePresenterDelegate
    }
}

//MARK: - EditNoteConfigurator
/***************************************************************/

extension EditNoteConfiguratorImpl: EditNoteConfigurator {
    func configure(editNoteViewController: EditNoteViewController) {        
        let presenter = EditNotePresenterImpl(view: editNoteViewController, note: note)
        presenter.delegate = editNotePresenterDelegate
        
        editNoteViewController.presenter = presenter
    }
}
