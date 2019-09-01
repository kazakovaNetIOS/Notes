//
//  EditNoteCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class EditNoteCoordinator {
    
    private let presenter: UINavigationController
    private var editNoteViewController: EditNoteViewController?
    private var note: Note
    private let notesManager: NotesManager
    
    init(presenter: UINavigationController,
         note: Note,
         notesManager: NotesManager) {
        self.presenter = presenter
        self.note = note
        self.notesManager = notesManager
    }
}

//MARK: - Coordinator
/***************************************************************/

extension EditNoteCoordinator: Coordinator {
    func start() {
        let editNoteViewController = EditNoteViewController.instantiateViewController()
        editNoteViewController.configurator = EditNoteConfiguratorImpl(note: note,
                                                                       editNotePresenterDelegate: self)
        
        presenter.pushViewController(editNoteViewController, animated: true)
        
        self.editNoteViewController = editNoteViewController
    }
}

//MARK: - EditNotePresenterDelegate
/***************************************************************/

extension EditNoteCoordinator: EditNotePresenterDelegate {
    func editNotePresenter(_ presenter: EditNotePresenter, didAdd note: Note) {
        notesManager.save(note) { [weak self] in
            guard let `self` = self else { return }
            self.presenter.popViewController(animated: true)
        }
    }
}
