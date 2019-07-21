//
//  PalletteViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 08/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {
    
    @IBOutlet weak var colorPicker: ColorPickerView!
    
    var delegate: ColorPickerControllerDelegate?
    var selectedColor: UIColor = UIColor.white
}

//MARK: - Lifecycle methods
extension ColorPickerController {
    override func viewDidLoad() {
        colorPicker.delegate = self
        colorPicker.selectedColor = selectedColor
    }
}

//MARK: - Overrides methods
extension ColorPickerController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.colorPicker.rotateGradient()
        })
    }
}

// MARK: ColorPickerDelegate methods
extension ColorPickerController: ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPickerView, willSelectColor color: UIColor) {
        delegate?.colorPickerController(self, willSelect: color)
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK: ColorPickerControllerDelegate protocol
protocol ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor)
}
