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
            
            DDLogDebug("The list of notes is sorted")
        }
    }
    var backgroundContext: NSManagedObjectContext! {
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
        loadData {
            DDLogDebug("After request token")
        }
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

//MARK: - Load data
/***************************************************************/

extension NotesListController {
    private func loadData(completion: (() -> Void)? = nil) {
        let loadNotes = LoadNotesOperation(notebook: notebook,
                                           backendQueue: OperationQueue(),
                                           dbQueue: OperationQueue(),
                                           backgroundContext: backgroundContext)
        loadNotes.completionBlock = { [weak self] in
            guard let sself = self else { return }
            
            sself.notes = loadNotes.result ?? []
            
            OperationQueue.main.addOperation {
                sself.notesListTableView.reloadData()
                DDLogDebug("Updating the table after loading data")
                
                completion?()
            }
        }
        OperationQueue().addOperation(loadNotes)
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
            
            DDLogDebug("Editing table switched to off")
        } else {
            notesListTableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
            
            DDLogDebug("Editing table switched to on")
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        noteForEditing = Note(title: "", content: "", importance: .ordinary, dateOfSelfDestruction: nil)
        
        DDLogDebug("Switch to note editing")
        
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
            editNoteVC.backgroundContext = backgroundContext
        }
    }
}

//MARK: - EditNoteControllerDelegate
/***************************************************************/

extension NotesListController: EditNoteControllerDelegate {
    func handleNoteEdited() {
        loadData {
            DDLogDebug("Updating data after saving a modified note")
        }
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
            let deletedNoteId = notes[indexPath.row].uid
            
            let removeNote = RemoveNoteOperation(noteId: deletedNoteId,
                                                 notebook: notebook,
                                                 backendQueue: OperationQueue(),
                                                 dbQueue: OperationQueue(),
                                                 backgroundContext: backgroundContext)
            removeNote.completionBlock = { [weak self] in
                guard let sself = self else { return }
                
                OperationQueue.main.addOperation {
                    sself.notes.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    DDLogDebug("Removed table row with index \(indexPath.row)")
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
