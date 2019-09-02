//
//  ColorPickerCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ColorPickerCoordinatorDelegate: class {
    func colorPicker(_ colorPicker: ColorPickerCoordinator, didSelect color: UIColor)
}

class ColorPickerCoordinator {
    
    private let presenter: UINavigationController
    private var colorPickerViewController: ColorPickerViewController?
    private var color: UIColor
    weak var delegate: ColorPickerCoordinatorDelegate?
    
    init(presenter: UINavigationController,
         color: UIColor) {
        self.presenter = presenter
        self.color = color
    }
}

//MARK: - Coordinator
/***************************************************************/

extension ColorPickerCoordinator: Coordinator {
    func start() {
        let colorPickerViewController = ColorPickerViewController.instantiateViewController()
            colorPickerViewController.configurator =
                ColorPicConfiguratorImpl(color: color,
                                         colorPickerPresenterDelegate: self)
    
        presenter.pushViewController(colorPickerViewController, animated: true)
        
        self.colorPickerViewController = colorPickerViewController
    }
}

//MARK: - ColorPickerPresenterDelegate
/***************************************************************/

extension ColorPickerCoordinator: ColorPickerPresenterDelegate {
    func colorPickerPresenter(_ presenter: ColorPickerPresenter, didSelect color: UIColor) {
        self.presenter.popViewController(animated: true)
        delegate?.colorPicker(self, didSelect: color)
    }
}
