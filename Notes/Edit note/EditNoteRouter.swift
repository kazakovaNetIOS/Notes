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
    func presentColorPicker(for: UIColor, colorPickerPresenterDelegate: ColorPickerPresenterDelegate)
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class EditNoteViewRouterImpl {
    
    private weak var editNoteViewController: EditNoteViewController?
    
    init(editNoteViewController: EditNoteViewController) {
        self.editNoteViewController = editNoteViewController
    }
}

//MARK: - EditNoteViewRouter
/***************************************************************/

extension EditNoteViewRouterImpl: EditNoteViewRouter {
    func presentColorPicker(for: UIColor, colorPickerPresenterDelegate: ColorPickerPresenterDelegate) {
        editNoteViewController?.performSegue(withIdentifier: "goToColorPicker", sender: nil)
    }
    
    func dismiss() {
        editNoteViewController?.navigationController?.popViewController(animated: true)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditNote",
            let colorPickerController = segue.destination as? ColorPickerController {
//            colorPickerController.delegate = self
//            colorPickerController.selectedColor = colorPickerTile.backgroundColor ?? UIColor.white
        }
    }
}
