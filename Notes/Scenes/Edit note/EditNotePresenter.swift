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
}

protocol EditNotePresenter {
    var router: EditNoteViewRouter { get }
    var titleForSaveButton: String { get }
    var note: Note { get }
    var color: UIColor { get }
    
    init(view: EditNoteView, router: EditNoteViewRouter, delegate: EditNotePresenterDelegate?, note: Note)
    
    func saveButtonPressed(parameters: EditNoteParameters)
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
    private(set) var color: UIColor
    
    required init(
        view: EditNoteView,
         router: EditNoteViewRouter,
         delegate: EditNotePresenterDelegate?,
         note: Note) {
        self.view = view
        self.router = router
        self.delegate = delegate
        self.note = note
        self.color = note.color
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
        router.presentColorPicker(for: self.color, colorPickerPresenterDelegate: self)
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

//MARK: - ColorPickerPresenterDelegate
/***************************************************************/

extension EditNotePresenterImpl: ColorPickerPresenterDelegate {
    func colorPickerPresenter(_ presenter: ColorPickerPresenter, didSelect color: UIColor) {
        presenter.router.dismiss()
        self.color = color
        view?.resetColorTilesState()
        view?.showSelectedColorFromPicker()
    }
}
