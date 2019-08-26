//
//  EditNoteRouter.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol EditNoteViewRouter {
    func dismiss()
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
    func dismiss() {
        editNoteViewController?.navigationController?.popViewController(animated: true)
    }
}
