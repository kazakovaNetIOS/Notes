//
//  NotesListViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 18/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class NotesListController: UIViewController {
    
    @IBOutlet weak var notesListTableView: UITableView!
    
    private let notebook = AppDelegate.noteBook
    private var newNote: Note?

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
    
    @objc func editButtonTapped(_ sender: UIButton) {
        print("edit button tapped")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        newNote = Note(title: "", content: "", importance: .ordinary, dateOfSelfDestruction: nil)
        notebook.add(newNote!)
        
        performSegue(withIdentifier: "goToEditNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
            let editNoteVC = segue.destination as? EditNoteController {
            editNoteVC.note = newNote
        }
    }
}

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
}

extension NotesListController: UITableViewDelegate {
    
}
