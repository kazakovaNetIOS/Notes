//
//  NotesCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class NotesCoordinator {
    
    private let presenter: UINavigationController
    private var notesViewController: NotesViewController?
    private let notesManager: NotesManager
    
    private var passwordCoordinator: Coordinator?
    private var editNoteCoordinator: Coordinator?
    
    init(presenter: UINavigationController,
         notesManager: NotesManager) {
        self.presenter = presenter
        self.notesManager = notesManager
        self.notesManager.delegate = self
    }
}

//MARK: - Coordinator
/***************************************************************/

extension NotesCoordinator: Coordinator {
    func start() {
        let notesViewController = NotesViewController.instantiateViewController()
        let notesPresenter = NotesPresenterImpl(manager: notesManager,
                                                view: notesViewController)
        notesPresenter.delegate = self
        notesViewController.presenter = notesPresenter
        self.notesViewController = notesViewController
        presenter.pushViewController(notesViewController, animated: true)
        notesManager.load()
    }
}

//MARK: - NotesManagerDelegate
/***************************************************************/

extension NotesCoordinator: NotesManagerDelegate {
    func requestAuth(with controller: AuthControllerProtocol) {
        guard let controller = controller as? UIViewController else { return }
        presenter.setNavigationBarHidden(true, animated: true)
        presenter.tabBarController?.tabBar.isHidden = true
        presenter.pushViewController(controller, animated: true)
    }
    
    func notesManagerDidLoadNotes(_ manager: NotesManager) {
        presenter.popViewController(animated: true)
        presenter.setNavigationBarHidden(false, animated: true)
        presenter.tabBarController?.tabBar.isHidden = false
        notesViewController?.presenter?.didLoadNotes()
    }
}

//MARK: - NotesPresenterDelegate
/***************************************************************/

extension NotesCoordinator: NotesPresenterDelegate {
    func notesPresenterDidAddOrEditNote(_ note: Note) {
        let editNoteCoordinator = EditNoteCoordinator(presenter: presenter, note: note, notesManager: notesManager)
        editNoteCoordinator.start()
        self.editNoteCoordinator = editNoteCoordinator
    }
    
    func notesPresentDidPasswordButtonTapped() {
        let passwordCoordinator = PasswordCoordinator(presenter: presenter)
        passwordCoordinator.start()
        self.passwordCoordinator = passwordCoordinator
    }
}
