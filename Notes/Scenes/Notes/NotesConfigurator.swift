//
//  NotesConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 02/09/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol NotesConfigurator {
    func configure(notesViewController: NotesViewController)
    init(notesManager: NotesManager, notesPresenterDelegate: NotesPresenterDelegate?)
}

class NotesConfiguratorImpl {
    
    var notesManager: NotesManager
    var notesPresenterDelegate: NotesPresenterDelegate?
    
    required init(notesManager: NotesManager, notesPresenterDelegate: NotesPresenterDelegate?) {
        self.notesManager = notesManager
        self.notesPresenterDelegate = notesPresenterDelegate
    }
}

//MARK: - NotesConfigurator
/***************************************************************/

extension NotesConfiguratorImpl: NotesConfigurator {
    func configure(notesViewController: NotesViewController) {
        let notesPresenter = NotesPresenterImpl(manager: notesManager,
                                                view: notesViewController)
        notesPresenter.delegate = notesPresenterDelegate
        notesViewController.presenter = notesPresenter
    }
}
