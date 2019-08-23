//
//  NotesListViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 18/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

protocol NotesListViewProtocol: class {
    func switchEditingModeOff()
    func switchEditingModeOn()
    func goToEditScreen(editedNote: Note)
    func showNoteList()
    func showDeletingNote(at index: IndexPath)
    func disableListEditing()
    func enableListEditing()
    func show(authController: AuthControllerProtocol)
}

class NotesListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var presenter: NotesListPresenterProtocol? {
        didSet {
            presenter?.didViewLoad()
        }
    }
    
    private var noteForEditing: Note?
    private let reuseIdentifier = "note cell"
}

//MARK: - Lifecycle methods
/***************************************************************/

extension NotesListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: - Setup views
/***************************************************************/

extension NotesListController {
    private func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - NotesListViewProtocol
/***************************************************************/

extension NotesListController: NotesListViewProtocol {
    func showDeletingNote(at index: IndexPath) {
        tableView.deleteRows(at: [index], with: .automatic)
    }
    
    func show(authController: AuthControllerProtocol) {
        guard let controller = authController as? UIViewController else { return }
        present(controller, animated: true, completion: nil)
    }
    
    func showNoteList() {
        tableView.reloadData()
    }
    
    func goToEditScreen(editedNote: Note) {
        noteForEditing = editedNote
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
    
    func switchEditingModeOff() {
        tableView.isEditing = false
        navigationItem.leftBarButtonItem?.title = "Edit"
    }
    
    func switchEditingModeOn() {
        tableView.isEditing = true
        navigationItem.leftBarButtonItem?.title = "Done"
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

extension NotesListController {
    @objc func editButtonTapped(_ sender: UIButton) {
        presenter?.didTapEditButton()
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        presenter?.didTapAddButton()
    }
}

//MARK: - Prepare for segue
/***************************************************************/

extension NotesListController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
            let editNoteVC = segue.destination as? EditNoteController {
            editNoteVC.note = noteForEditing
            editNoteVC.delegate = self
        }
    }
}

//MARK: - EditNoteControllerDelegate
/***************************************************************/

extension NotesListController: EditNoteControllerDelegate {
    func handleNoteEdited(note: Note) {
        presenter?.didEndEdit(note: note)
    }
}

//MARK: - UITableViewDataSource
/***************************************************************/

extension NotesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfNotes() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        guard let note = presenter?.note(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.titleLabel?.text = note.title
        cell.contentLabel?.text = note.content
        cell.colorTileView?.backgroundColor = note.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.didSwipeLeftRow(at: indexPath)
        }
    }
}

//MARK: - UITableViewDelegate
/***************************************************************/

extension NotesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteForEditing = presenter?.note(at: indexPath.row)
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
}
