//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 08/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var colorPicker: ColorPickerViewXIB!
    
    var configurator: ColorPicConfigurator!
    var presenter: ColorPickerPresenter!
}

//MARK: - ColorPickerView
/***************************************************************/

extension ColorPickerViewController: ColorPickerView {
    func showColor(color: UIColor) {
        colorPicker.selectedColor = color
    }
}

//MARK: - Overrides methods
extension ColorPickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(colorPickerController: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.colorPicker.rotateGradient()
        })
    }
}

//MARK: - StoryboardInstantiable
/***************************************************************/

extension ColorPickerViewController: StoryboardInstantiable { }
