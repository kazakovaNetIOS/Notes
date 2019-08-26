//
//  EditNotePresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

struct EditNoteParameters {
    let title: String?
    let content: String?
    let dateOfSelfDestruction: Date?
}

protocol EditNoteView: class {
    func showSelectedColorFromPicker(color: UIColor)
    func showSelectedColorFromTile(tag: Int)
    func resetColorTilesState()
    func showDestroyDatePicker(with date: Date)
    func hideDestroyDatePicker()
}

protocol EditNotePresenterDelegate: class {
    func editNotePresenter(_ presenter: EditNotePresenter, didAdd note: Note)
    func editNotePresenterCancel(presenter: EditNotePresenter)
}

protocol EditNotePresenter {
    var router: EditNoteViewRouter { get }
    var titleForSaveButton: String { get }
    var note: Note { get }
    func saveButtonPressed(parameters: EditNoteParameters)
    func colorDidSelectFromPicker(with color: UIColor)
    func colorDidSelectFromTile(with color: UIColor, tag: Int)
    func colorPickerLongPressed()
    func useDestroyDateSwitched(state: Bool)
    func viewDidLoad()
}

class EditNotePresenterImpl {
    
    private weak var view: EditNoteView?
    private(set) var router: EditNoteViewRouter
    private(set) var note: Note
    private weak var delegate: EditNotePresenterDelegate?
    public var titleForSaveButton: String {
        return "Сохранить"
    }
    private var isColorChanged: Bool = false
    private var selectedColor: UIColor
    
    init(
        view: EditNoteView,
         router: EditNoteViewRouter,
         delegate: EditNotePresenterDelegate?,
         note: Note) {
        self.view = view
        self.router = router
        self.delegate = delegate
        self.note = note
        self.selectedColor = note.color
    }
}

//MARK: - EditNotePresenter
/***************************************************************/

extension EditNotePresenterImpl: EditNotePresenter {
    func viewDidLoad() {
        if let date = note.dateOfSelfDestruction {
            view?.showDestroyDatePicker(with: date)
        }
    }
    
    func useDestroyDateSwitched(state: Bool) {
        switch state {
        case true:
            view?.showDestroyDatePicker(with: note.dateOfSelfDestruction ?? Date())
        case false:
            view?.hideDestroyDatePicker()
        }
    }
    
    func colorPickerLongPressed() {
        router.presentColorPicker(for: selectedColor, colorPickerPresenterDelegate: self) 
    }
    
    func colorDidSelectFromTile(with color: UIColor, tag: Int) {
        selectedColor = color
        isColorChanged = true
        view?.showSelectedColorFromTile(tag: tag)
    }
    
    func colorDidSelectFromPicker(with color: UIColor) {
        view?.showSelectedColorFromPicker(color: color)
        
        selectedColor = color
        isColorChanged = true
    }
    
    func saveButtonPressed(parameters: EditNoteParameters) {
        delegate?.editNotePresenter(self, didAdd: Note(uid: note.uid,
                                                       title: parameters.title ?? "",
                                                       content: parameters.content ?? "",
                                                       color: selectedColor,
                                                       importance: note.importance,
                                                       dateOfSelfDestruction: parameters.dateOfSelfDestruction))
    }
}

//MARK: - ColorPickerPresenterDelegate
/***************************************************************/

extension EditNotePresenterImpl: ColorPickerPresenterDelegate {
    
}
