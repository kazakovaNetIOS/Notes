//
//  NotesViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 18/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var presenter: NotesPresenter? {
        didSet {
            presenter?.viewDidLoad()
        }
    }
    
    private var noteForEditing: Note?
    private let reuseIdentifier = "note cell"
}

//MARK: - Lifecycle methods
/***************************************************************/

extension NotesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: - Setup views
/***************************************************************/

extension NotesViewController {
    private func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", //TODO: - FIX
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - NotesView
/***************************************************************/

extension NotesViewController: NotesView {
    func deleteAnimated(at index: IndexPath) {
        tableView.deleteRows(at: [index], with: .automatic)
    }
    
    func show(authController: AuthControllerProtocol) {
        guard let controller = authController as? UIViewController else { return }
        present(controller, animated: true, completion: nil)
    }
    
    func refreshNotesView() {
        tableView.reloadData()
    }
    
    func switchEditingModeOff() {
        tableView.isEditing = false
        navigationItem.leftBarButtonItem?.title = presenter?.titleForEditButton
    }
    
    func switchEditingModeOn() {
        tableView.isEditing = true
        navigationItem.leftBarButtonItem?.title = presenter?.titleForDoneButton
    }
    
    func disableListEditing() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    func enableListEditing() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
}

//MARK: - Selector methods
/***************************************************************/

extension NotesViewController {
    @objc func editButtonTapped(_ sender: UIButton) {
        presenter?.didTapEditButton()
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        presenter?.didTapAddButton()
    }
}

//MARK: - Prepare for segue
/***************************************************************/

extension NotesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter?.router.prepare(for: segue, sender: sender)
    }
}

//MARK: - EditNoteControllerDelegate
/***************************************************************/

extension NotesViewController: EditNoteControllerDelegate {
    func handleNoteEdited(note: Note) {
        presenter?.didEndEdit(note: note)
    }
}

//MARK: - UITableViewDataSource
/***************************************************************/

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfNotes ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        presenter?.configure(cell: cell, forRow: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteButtonPressed(at: indexPath)
        }
    }
}

//MARK: - UITableViewDelegate
/***************************************************************/

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelect(row: indexPath.row)
    }
}
