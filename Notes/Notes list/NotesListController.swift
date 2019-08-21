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

class NotesListController: UIViewController {
    
    @IBOutlet weak var notesListTableView: UITableView!
    
    private let notebook = FileNotebook()
    private var notes: [Note] = [] {
        didSet {
            notes.sort(by: { $0.title < $1.title })
        }
    }
    public var backgroundContext: NSManagedObjectContext! {
        didSet {
            guard first else { return }
            AuthManager.shared.authCheck()
            first = false
        }
    }
    
    private var noteForEditing: Note?
    private let reuseIdentifier = "note cell"
    private var first = true
}

//MARK: - AuthManagerDelegate
/***************************************************************/

extension NotesListController: AuthManagerDelegate {    
    func authPassed() {
        loadData()
    }
    func show(_ authController: UIViewController) {
        present(authController, animated: false, completion: nil)
    }
}

//MARK: - Lifecycle methods
/***************************************************************/

extension NotesListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthManager.shared.delegate = self
        setupViews()
    }
}

//MARK: - Setup views
/***************************************************************/

extension NotesListController {
    private func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
        notesListTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - Selector methods
/***************************************************************/

extension NotesListController {
    @objc func editButtonTapped(_ sender: UIButton) {
        if(notesListTableView.isEditing == true) {
            notesListTableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        } else {
            notesListTableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        noteForEditing = Note(title: "", content: "", importance: .ordinary, dateOfSelfDestruction: nil)
        self.performSegue(withIdentifier: "goToEditNote", sender: self)
    }
}

//MARK: - Prepare for segue
/***************************************************************/

extension NotesListController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
            let editNoteVC = segue.destination as? EditNoteController {
            editNoteVC.note = noteForEditing
            editNoteVC.notebook = notebook
            editNoteVC.delegate = self
        }
    }
}

//MARK: - EditNoteControllerDelegate
/***************************************************************/

extension NotesListController: EditNoteControllerDelegate {
    func handleNoteEdited(note: Note) {
        notes.replace(note: note)
        notesListTableView.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        let saveNoteOperation = SaveNoteOperation(notes: notes,
                                                  backendQueue: OperationQueue(),
                                                  dbQueue: OperationQueue(),
                                                  backgroundContext: backgroundContext)
        saveNoteOperation.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            OperationQueue.main.addOperation {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
        OperationQueue().addOperation(saveNoteOperation)
    }
}

//MARK: - Load data
/***************************************************************/

extension NotesListController {
    private func loadData() {
        let loadNotes = LoadNotesOperation(backendQueue: OperationQueue(),
                                           dbQueue: OperationQueue(),
                                           backgroundContext: backgroundContext)
        loadNotes.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            OperationQueue.main.addOperation {
                self.notes = loadNotes.result ?? []
                self.notesListTableView.reloadData()
            }
        }
        OperationQueue().addOperation(loadNotes)
    }
}

//MARK: - UITableViewDataSource
/***************************************************************/

extension NotesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.titleLabel?.text = note.title
        cell.contentLabel?.text = note.content
        cell.colorTileView?.backgroundColor = note.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            let removeNote = RemoveNoteOperation(notes: notes,
                                                 backendQueue: OperationQueue(),
                                                 dbQueue: OperationQueue(),
                                                 backgroundContext: backgroundContext)
            removeNote.completionBlock = {
                OperationQueue.main.addOperation {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            OperationQueue().addOperation(removeNote)
        }
    }
}

//MARK: - UITableViewDelegate
/***************************************************************/

extension NotesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteForEditing = notes[indexPath.row]
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
}
