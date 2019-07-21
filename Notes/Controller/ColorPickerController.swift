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
    var selectedColor: UIColor = UIColor.white
    
    override func viewDidLoad() {        
        colorPicker.delegate = self
        colorPicker.selectedColor = selectedColor
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.colorPicker.rotateGradient()
        })
    }
}

// MARK: ColorPickerDelegate
extension ColorPickerController: ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPicker, willSelectColor color: UIColor) {
        delegate?.colorPickerController(self, willSelect: color)
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: ColorPickerControllerDelegate
protocol ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor)
}
