//
//  NotesListViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 18/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class NotesListController: UIViewController {
    
    private var notesList: [Note] = []
    private let notebook = FileNotebook()
    private var newNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        notesList = notebook.getDummyData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        print("edit button tapped")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        print("add button tapped")
        
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

extension NotesListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let note = notesList[indexPath.row]
        
        cell.textLabel?.text = note.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = note.content
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
}
