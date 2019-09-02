//
//  ColorPickerConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 26/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ColorPicConfigurator {
    func configure(colorPickerController: ColorPickerViewController)
    init(color: UIColor, colorPickerPresenterDelegate: ColorPickerPresenterDelegate?)
}

class ColorPicConfiguratorImpl {
    
    var color: UIColor
    var colorPickerPresenterDelegate: ColorPickerPresenterDelegate?
    
    required init(color: UIColor, colorPickerPresenterDelegate: ColorPickerPresenterDelegate?) {
        self.color = color
        self.colorPickerPresenterDelegate = colorPickerPresenterDelegate
    }
}

//MARK: - ColorPicConfigurator
/***************************************************************/

extension ColorPicConfiguratorImpl: ColorPicConfigurator {
    func configure(colorPickerController: ColorPickerViewController) {
        let presenter = ColorPickerPresenterImpl(view: colorPickerController,
                                                 color: color)
        presenter.delegate = colorPickerPresenterDelegate
        colorPickerController.presenter = presenter
        colorPickerController.colorPicker.delegate = presenter
    }
}
