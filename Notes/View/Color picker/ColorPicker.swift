//
//  ColorPicker.swift
//  Notes
//
//  Created by Natalia Kazakova on 10/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPicker: UIView {
    
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var colorPickerFrame: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var hexValueColorLabel: UILabel!
    @IBOutlet weak var paletteView: PaletteView!
    @IBOutlet weak var targetImageView: TargetImageView!
    
    internal var delegate: ColorPickerDelegate?
    
    private var location: CGPoint = CGPoint(x: 0, y: 0) {
        willSet {
            if colorPickerFrame.bounds.minX...colorPickerFrame.bounds.maxX ~= newValue.x,
                colorPickerFrame.bounds.minY...colorPickerFrame.bounds.maxY ~= newValue.y {
                selectedColor = paletteView.getColor(at: newValue) ?? UIColor.white
                
                targetImageView.move(at: newValue)
                targetImageView.background(with: selectedColor)
            }
        }
    }
    
    internal var selectedColor: UIColor = .white {
        willSet {
            selectedColorView.backgroundColor = newValue
            brightnessSlider.value = Float(newValue.rgba.alpha)
            paletteView.brightness = CGFloat(newValue.rgba.alpha)
            
            hexValueColorLabel.text = newValue.toHexString()
            targetImageView.background(with: newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        location = touch.location(in: colorPickerFrame)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        location = touch.location(in: colorPickerFrame)
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(xibView)
        
        selectedColorView.layer.borderColor = UIColor.black.cgColor
        selectedColorView.layer.borderWidth = 1
        selectedColorView.layer.cornerRadius = 10
        
        colorPickerFrame.layer.borderColor = UIColor.black.cgColor
        colorPickerFrame.layer.borderWidth = 1
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPicker", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    internal func rotateGradient() {
        colorPickerFrame.alpha = 0
        paletteView.rotate()
        targetImageView.hide()
        
        UIView.animate(withDuration: 0.7) {
            self.colorPickerFrame.alpha = 1
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.colorPicker(self, willSelectColor: selectedColor)
    }
    
    @IBAction func brightnessSliderChanged(_ sender: UISlider) {
        selectedColor = selectedColor.withAlphaComponent(CGFloat(sender.value))
    }
}

internal protocol ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPicker, willSelectColor color: UIColor)
}
