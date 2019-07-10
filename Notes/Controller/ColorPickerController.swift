//
//  PalletteViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 08/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {
    
    @IBOutlet weak var colorPicker: ColorPicker!
    var delegate: ColorPickerControllerDelegate?
    
    override func viewDidLoad() {        
        colorPicker.delegate = self
    }
}

// MARK: - ColorPickerDelegate
extension ColorPickerController: ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPicker, willSelectColor color: UIColor) {
        delegate?.colorPickerController(self, willSelect: color)
        navigationController?.popToRootViewController(animated: true)
    }
}

protocol ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor)
}
