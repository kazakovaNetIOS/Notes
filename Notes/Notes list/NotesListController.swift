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
    private var noteForEditing: Note?
}

//MARK: - Lifecycle methods
extension NotesListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notebook.loadDummyData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notesListTableView.reloadData()
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
        notebook.add(noteForEditing!)
        
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
}

//MARK: - Overrides methods
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
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let note = notebook.notes[indexPath.row]
        
        cell.textLabel?.text = note.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = note.content
        cell.detailTextLabel?.numberOfLines = 0
        
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
        noteForEditing = notebook.notes[indexPath.row]
        
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
}

//MARK: - Model manipulate methods
extension NotesListController {
    private func deleteNote(at indexPath: IndexPath) {
        let deletedNote = notebook.notes[indexPath.row]
        notebook.remove(with: deletedNote.uid)
        
        DDLogDebug("Delete table row at index \(indexPath.row)")
    }
}
