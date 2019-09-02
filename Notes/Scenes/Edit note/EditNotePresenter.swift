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
    func showSelectedColorFromPicker()
    func showSelectedColorFromTile(with tag: Int)
    func resetColorTilesState()
    func showDestroyDatePicker(with date: Date)
    func hideDestroyDatePicker()
}

protocol EditNotePresenterDelegate: class {
    func editNotePresenter(_ presenter: EditNotePresenter, didAdd note: Note)
    func showColorPicker(for: UIColor)
}

protocol EditNotePresenter {
    var titleForSaveButton: String { get }
    var note: Note { get }
    var color: UIColor { get }
    
    init(view: EditNoteView, note: Note)
    
    func saveButtonPressed(parameters: EditNoteParameters)
    func colorDidSelectFromTile(with color: UIColor, tag: Int)
    func colorDidSelectFromPicker(with color: UIColor)
    func colorPickerLongPressed()
    func useDestroyDateSwitched(state: Bool)
    func viewDidLoad()
}

class EditNotePresenterImpl {
    
    private weak var view: EditNoteView?
    private(set) var note: Note
    weak var delegate: EditNotePresenterDelegate?
    public var titleForSaveButton: String {
        return "Сохранить"
    }
    private(set) var color: UIColor
    
    required init(
        view: EditNoteView,
         note: Note) {
        self.view = view
        self.note = note
        self.color = note.color
    }
}

//MARK: - EditNotePresenter
/***************************************************************/

extension EditNotePresenterImpl: EditNotePresenter {
    func colorDidSelectFromPicker(with color: UIColor) {
        view?.resetColorTilesState()
        self.color = color
        view?.showSelectedColorFromPicker()
    }
    
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
        delegate?.showColorPicker(for: self.color)
    }
    
    func colorDidSelectFromTile(with color: UIColor, tag: Int) {
        self.color = color
        view?.showSelectedColorFromTile(with: tag)
    }
    
    func saveButtonPressed(parameters: EditNoteParameters) {
        delegate?.editNotePresenter(self, didAdd: Note(uid: note.uid,
                                                       title: parameters.title ?? "",
                                                       content: parameters.content ?? "",
                                                       color: self.color,
                                                       importance: note.importance,
                                                       dateOfSelfDestruction: parameters.dateOfSelfDestruction))
    }
}
