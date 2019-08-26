//
//  EditNoteRouter.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol EditNoteViewRouter {
    func dismiss()
    func presentColorPicker(for color: UIColor, colorPickerPresenterDelegate: ColorPickerPresenterDelegate)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class EditNoteViewRouterImpl {
    
    private weak var editNoteViewController: EditNoteViewController?
    private weak var colorPickerPresenterDelegate: ColorPickerPresenterDelegate?
    private var color: UIColor!
    
    init(editNoteViewController: EditNoteViewController) {
        self.editNoteViewController = editNoteViewController
    }
}

//MARK: - EditNoteViewRouter
/***************************************************************/

extension EditNoteViewRouterImpl: EditNoteViewRouter {
    func presentColorPicker(for color: UIColor, colorPickerPresenterDelegate: ColorPickerPresenterDelegate) {
        self.colorPickerPresenterDelegate = colorPickerPresenterDelegate
        self.color = color
        editNoteViewController?.performSegue(withIdentifier: "goToColorPicker", sender: nil)
    }
    
    func dismiss() {
        editNoteViewController?.navigationController?.popViewController(animated: true)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToColorPicker",
            let colorPickerController = segue.destination as? ColorPickerViewController {
            colorPickerController.configurator =
                ColorPicConfiguratorImpl(color: color,
                                         colorPickerPresenterDelegate: colorPickerPresenterDelegate)
        }
    }
}
