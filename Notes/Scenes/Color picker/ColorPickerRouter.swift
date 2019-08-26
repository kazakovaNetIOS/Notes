//
//  ColorPickerRouter.swift
//  Notes
//
//  Created by Natalia Kazakova on 26/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ColorPickerRouter {
    func dismiss()
}

class ColorPickerRouterImpl {
    
    private weak var colorPickerController: ColorPickerViewController?
    
    init(colorPickerController: ColorPickerViewController) {
        self.colorPickerController = colorPickerController
    }
}

//MARK: - EditNoteViewRouter
/***************************************************************/

extension ColorPickerRouterImpl: ColorPickerRouter {
    func dismiss() {
        colorPickerController?.navigationController?.popViewController(animated: true)
    }
}
