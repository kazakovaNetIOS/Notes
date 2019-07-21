//
//  EditNoteController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class EditNoteController: UIViewController {
    
    @IBOutlet weak var editNoteViewContainer: UIView!
    
    var note: Note?
    private weak var editNoteView: EditNoteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editNoteView = EditNoteView(frame: editNoteViewContainer.frame, displayNote: note)
        editNoteView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        editNoteView.translatesAutoresizingMaskIntoConstraints = true
        
        editNoteViewContainer.addSubview(editNoteView)
        
        editNoteView.delegate = self
        self.editNoteView = editNoteView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped(_:)))
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        guard let editedNote = editNoteView.editedNote else {
            return
        }
        
        note = editedNote
        AppDelegate.noteBook.remove(with: editedNote.uid)
        AppDelegate.noteBook.add(editedNote)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorPickerController = segue.destination as? ColorPickerController  else { return }
        
        colorPickerController.delegate = self
        colorPickerController.selectedColor = editNoteView.colorPickerTile.backgroundColor ?? UIColor.white
    }
}

// MARK: - EditNoteColorPickerTileDelegate
extension EditNoteController: EditNoteColorPickerTileDelegate {
    func editNoteColorPickerTileDidLongPress(_ editNote: EditNoteView) {
        performSegue(withIdentifier: "goToColorPicker", sender: self)
    }
}

// MARK: - ColorPickerControllerDelegate
extension EditNoteController: ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor) {
        editNoteView.colorPickerTile.image = nil
        editNoteView.colorPickerTile.backgroundColor = color
        editNoteView.selectedColor = color
        editNoteView.showCheckIcon(tag: 4)
    }
}

