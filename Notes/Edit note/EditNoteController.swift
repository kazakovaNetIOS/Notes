//
//  EditNoteController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

protocol EditNoteControllerDelegate {
    func handleNoteEdited()
}

class EditNoteController: UIViewController {
    
    @IBOutlet weak var editNoteViewContainer: UIView!
    
    var delegate: EditNoteControllerDelegate?
    var backgroundContext: NSManagedObjectContext!
    
    var note: Note?
    var notebook: FileNotebook!
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
        
        let saveNoteOperation = SaveNoteOperation(note: editedNote,
                                                  notebook: notebook,
                                                  backendQueue: OperationQueue(),
                                                  dbQueue: OperationQueue(),
                                                  backgroundContext: backgroundContext)
        
        saveNoteOperation.completionBlock = { [weak self] in
            guard let sself = self else { return }
            
            OperationQueue.main.addOperation {
                DDLogDebug("Return to the list of notes")
                
                sself.delegate?.handleNoteEdited()
                sself.navigationController?.popViewController(animated: true)
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

