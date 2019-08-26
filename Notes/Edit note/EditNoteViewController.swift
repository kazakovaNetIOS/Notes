//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    @IBOutlet weak var editNoteViewContainer: UIView!
    
    var configurator: EditNoteConfigurator!
    var presenter: EditNotePresenter!
    
    var note: Note?
    private weak var editNoteView: EditNoteXIB!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(editNoteViewController: self)
        setupViews()
    }
}

//MARK: - EditNoteView
/***************************************************************/

extension EditNoteViewController: EditNoteView {
    
}

//MARK: - Setup views
/***************************************************************/
extension EditNoteViewController {
    private func setupViews() {
        let editNoteView = EditNoteXIB(frame: editNoteViewContainer.frame, displayNote: note)
        editNoteView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        editNoteView.translatesAutoresizingMaskIntoConstraints = true
        
        editNoteViewContainer.addSubview(editNoteView)
        
        editNoteView.delegate = self
        self.editNoteView = editNoteView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: presenter.titleForSaveButton, style: .plain, target: self, action: #selector(saveButtonTapped))
    }
}


//MARK: - Prepare for segue
/***************************************************************/

extension EditNoteViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorPickerController = segue.destination as? ColorPickerController  else { return }
        
        colorPickerController.delegate = self
        colorPickerController.selectedColor = editNoteView.colorPickerTile.backgroundColor ?? UIColor.white
    }
}

//MARK: - Selector methods
/***************************************************************/

extension EditNoteViewController {
    @objc func saveButtonTapped(_ sender: UIButton) {
        guard let editedNote = editNoteView.editedNote else {
            return
        }
        
        presenter.saveButtonPressed(note: editedNote)
    }
}

// MARK: - EditNoteColorPickerTileDelegate
/***************************************************************/

extension EditNoteViewController: EditNoteColorPickerTileDelegate {
    func editNoteColorPickerTileDidLongPress(_ editNote: EditNoteXIB) {
        performSegue(withIdentifier: "goToColorPicker", sender: self)
    }
}

// MARK: - ColorPickerControllerDelegate
/***************************************************************/

extension EditNoteViewController: ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor) {
        editNoteView.colorPickerTile.image = nil
        editNoteView.colorPickerTile.backgroundColor = color
        editNoteView.firstColorTile.backgroundColor = .white
        editNoteView.selectedColor = color
        editNoteView.isColorChanged = true
        editNoteView.showCheckIcon(tag: 4)
    }
}

