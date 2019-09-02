//
//  ColorPickerViewXIB.swift
//  Notes
//
//  Created by Natalia Kazakova on 10/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerViewXIB: UIView {
    
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var colorPickerFrame: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var hexValueColorLabel: UILabel!
    @IBOutlet weak var paletteView: PaletteView!
    @IBOutlet weak var targetImageView: TargetImageView!
    
    var delegate: ColorPickerDelegate?
    
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
    
    var selectedColor: UIColor = .white {
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
    
    func rotateGradient() {
        colorPickerFrame.alpha = 0
        paletteView.rotate()
        targetImageView.hide()
        
        UIView.animate(withDuration: 0.7) {
            self.colorPickerFrame.alpha = 1
        }
    }
}

//MARK: - IBAction
extension ColorPickerViewXIB {
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.colorPicker(self, willSelectColor: selectedColor)
    }
    
    @IBAction func brightnessSliderChanged(_ sender: UISlider) {
        selectedColor = selectedColor.withAlphaComponent(CGFloat(sender.value))
    }
}

//MARK: - Setup views methods
extension ColorPickerViewXIB {
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
        let nib = UINib(nibName: "ColorPickerViewXIB", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}

//MARK: - Overrides methods
extension ColorPickerViewXIB {
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
}

protocol ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPickerViewXIB, willSelectColor color: UIColor)
}

//MARK: - PaletteView class
@IBDesignable
class PaletteView: UIView {
    
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    public var brightness: CGFloat = 1 {
        willSet {
            createGradientLayer()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        createGradientLayer()
    }
    
    private func createGradientLayer() {
        let colorSets = [
            UIColor.red.withAlphaComponent(brightness).cgColor,
            UIColor.orange.withAlphaComponent(brightness).cgColor,
            UIColor.yellow.withAlphaComponent(brightness).cgColor,
            UIColor.green.withAlphaComponent(brightness).cgColor,
            UIColor.blue.withAlphaComponent(brightness).cgColor,
            UIColor(red: 66.0/255, green: 170.0/255, blue: 255/255, alpha: brightness).cgColor,
            UIColor(red: 139.0/255, green: 0/255, blue: 255/255, alpha: brightness).cgColor,
            UIColor.white.withAlphaComponent(brightness).cgColor,
            UIColor.black.withAlphaComponent(brightness).cgColor
        ]
        
        gradientLayer.frame = frame
        gradientLayer.colors = colorSets
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.addSublayer(gradientLayer)
    }
    
    public func getColor(at point: CGPoint) -> UIColor? {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        context.translateBy(x: -point.x, y: -point.y)
        
        gradientLayer.render(in: context)
        
        let color = UIColor(red:   CGFloat(pixel[0]) / 255.0,
                            green: CGFloat(pixel[1]) / 255.0,
                            blue:  CGFloat(pixel[2]) / 255.0,
                            alpha: CGFloat(pixel[3]) / 255.0)
        pixel.deallocate()
        
        return getColorWithAlpha(with: color)
    }
    
    private func getColorWithAlpha(with color: UIColor) -> UIColor {
        return color.withAlphaComponent(brightness)
    }
    
    public func rotate() {
        gradientLayer.frame = bounds
    }
}

//MARK: - TargetImageView class
@IBDesignable
class TargetImageView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = max(frame.width / 2, frame.height / 2)
        layer.masksToBounds = true
        
        backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    public func move(at point: CGPoint) {
        isHidden = false
        frame.origin.x = point.x - frame.width / 2
        frame.origin.y = point.y - frame.height / 2
    }
    
    public func background(with color: UIColor) {
        backgroundColor = color
    }
    
    public func hide() {
        isHidden = true
    }
}
