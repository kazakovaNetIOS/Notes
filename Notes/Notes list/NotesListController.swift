//
//  NotesListViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 18/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack

class NotesListController: UIViewController {
    
    @IBOutlet weak var notesListTableView: UITableView!
    
    private let notebook = AppDelegate.noteBook
    private var notes: [Note] = [] {
        didSet {
            notes.sort(by: { $0.title < $1.title })
            
            DDLogDebug("The list of notes is sorted")
        }
    }
    
    private var noteForEditing: Note?
    private let reuseIdentifier = "note cell"
}

//MARK: - Lifecycle methods
extension NotesListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
        
        notesListTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loadNotes = LoadNotesOperation(notebook: AppDelegate.noteBook,
                                           backendQueue: OperationQueue(),
                                           dbQueue: OperationQueue())
        loadNotes.completionBlock = {
            let loadedNotes = loadNotes.result ?? []
            
            DDLogDebug("Downloading notes completed. Uploaded \(loadedNotes.count) notes")
            
            self.notes = loadedNotes
            
            let updateUI = BlockOperation {
                DDLogDebug("Updating the table after loading data")
                
                self.notesListTableView.reloadData()
            }
            
            OperationQueue.main.addOperation(updateUI)
        }
        
        OperationQueue().addOperation(loadNotes)
    }
}

//MARK: - Selector methods
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
        
        let saveNoteOperation = SaveNoteOperation(note: noteForEditing!, notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        
        saveNoteOperation.completionBlock = {
            DDLogDebug("Note saved. Note ID: \(self.noteForEditing!.uid)")
            
            let updateUI = BlockOperation {
                DDLogDebug("Switch to note editing")
                
                self.performSegue(withIdentifier: "goToEditNote", sender: self)
            }
            
            OperationQueue.main.addOperation(updateUI)
        }
        
        OperationQueue().addOperation(saveNoteOperation)
    }
}

//MARK: - Override methods
extension NotesListController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
            let editNoteVC = segue.destination as? EditNoteController {
            editNoteVC.note = noteForEditing
        }
    }
}

//MARK: - Table view data source methods
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
            deleteNote(at: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - Table view delegate methods
extension NotesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteForEditing = notes[indexPath.row]
        
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
}

//MARK: - Model manipulate methods
extension NotesListController {
    private func deleteNote(at indexPath: IndexPath) {
        let deletedNote = notes[indexPath.row]
        notebook.remove(with: deletedNote.uid)
        
        DDLogDebug("Delete table row at index \(indexPath.row)")
    }
}
