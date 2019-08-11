//
//  EditNoteController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack

protocol EditNoteControllerDelegate {
    func handleDataStorage()
}

class EditNoteController: UIViewController {
    
    @IBOutlet weak var editNoteViewContainer: UIView!
    
    var delegate: EditNoteControllerDelegate?
    
    var note: Note?
    private weak var editNoteView: EditNoteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

//MARK: - Setup views
/***************************************************************/
extension EditNoteController {
    private func setupViews() {
        let editNoteView = EditNoteView(frame: editNoteViewContainer.frame, displayNote: note)
        editNoteView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        editNoteView.translatesAutoresizingMaskIntoConstraints = true
        
        editNoteViewContainer.addSubview(editNoteView)
        
        editNoteView.delegate = self
        self.editNoteView = editNoteView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped(_:)))
    }
}


//MARK: - Prepare for segue
/***************************************************************/

extension EditNoteController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorPickerController = segue.destination as? ColorPickerController  else { return }
        
        colorPickerController.delegate = self
        colorPickerController.selectedColor = editNoteView.colorPickerTile.backgroundColor ?? UIColor.white
    }
}

//MARK: - Save data
/***************************************************************/

extension EditNoteController {
    private func saveNote() {
        guard let editedNote = editNoteView.editedNote else {
            return
        }
        
        AppDelegate.noteBook.add(note: editedNote)
        let saveNoteOperation = SaveNoteOperation(note: editedNote, notebook: AppDelegate.noteBook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        
        saveNoteOperation.completionBlock = {
            OperationQueue.main.addOperation {
                DDLogDebug("Return to the list of notes")
                
                self.delegate?.handleDataStorage()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        OperationQueue().addOperation(saveNoteOperation)
    }
}

//MARK: - Selector methods
/***************************************************************/

extension EditNoteController {
    @objc func saveButtonTapped(_ sender: UIButton) {
        saveNote()
    }
}

// MARK: - EditNoteColorPickerTileDelegate
/***************************************************************/

extension EditNoteController: EditNoteColorPickerTileDelegate {
    func editNoteColorPickerTileDidLongPress(_ editNote: EditNoteView) {
        performSegue(withIdentifier: "goToColorPicker", sender: self)
    }
}

// MARK: - ColorPickerControllerDelegate
/***************************************************************/

extension EditNoteController: ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor) {
        editNoteView.colorPickerTile.image = nil
        editNoteView.colorPickerTile.backgroundColor = color
        editNoteView.firstColorTile.backgroundColor = .white
        editNoteView.selectedColor = color
        editNoteView.isColorChanged = true
        editNoteView.showCheckIcon(tag: 4)
    }
}

