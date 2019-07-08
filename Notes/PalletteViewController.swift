//
//  PalletteViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 08/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class PalletteViewController: UIViewController, ColorPickerViewDelegate {
    
    @IBOutlet weak var selectColorTile: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var colorPickerFrame: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    var delegate: PalleteProtocol?
    var selectedColor: UIColor = .white
    
    override func viewDidLoad() {
        selectColorTile.layer.borderColor = UIColor.black.cgColor
        selectColorTile.layer.borderWidth = 1
        selectColorTile.layer.cornerRadius = 10
        
        colorPickerFrame.layer.borderColor = UIColor.black.cgColor
        colorPickerFrame.layer.borderWidth = 1
        
        colorPickerView.delegate = self
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.onColorSelected(color: selectedColor)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func colorPickerTouched(sender: ColorPickerView, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        selectColorTile.backgroundColor = color
        selectedColor = color
    }
}

protocol PalleteProtocol {
    func onColorSelected(color: UIColor)
}
