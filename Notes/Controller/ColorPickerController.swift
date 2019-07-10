//
//  PalletteViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 08/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {
    
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var colorPickerFrameView: UIView!
    @IBOutlet weak var colorPicker: ColorPicker!
    
    var delegate: ColorPickerViewDelegate?
    
    var selectedColor: UIColor = .white {
        willSet {
            selectedColorView.backgroundColor = newValue
        }
    }
    
    override func viewDidLoad() {
        selectedColorView.layer.borderColor = UIColor.black.cgColor
        selectedColorView.layer.borderWidth = 1
        selectedColorView.layer.cornerRadius = 10
        
        colorPickerFrameView.layer.borderColor = UIColor.black.cgColor
        colorPickerFrameView.layer.borderWidth = 1
        
        colorPicker.delegate = self
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.colorPickerView(self, willSelectColor: selectedColor)
        
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - ColorPickerDelegate
extension ColorPickerController: ColorPickerDelegate {
    func colorPickerTouched(sender: ColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        selectedColor = color
    }
}

protocol ColorPickerViewDelegate {
    func colorPickerView(_ colorPickerController: ColorPickerController, willSelectColor color: UIColor)
}
