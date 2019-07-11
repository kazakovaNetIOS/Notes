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
    
    private var targetImageView: UIImageView!
    private var gradientLayer: CAGradientLayer!
    internal var delegate: ColorPickerDelegate?
    
    private var location: CGPoint = CGPoint(x: 0, y: 0) {
        willSet {
            if 0...gradientLayer.bounds.size.width ~= location.x,
                0...gradientLayer.bounds.size.height ~= location.y {
                selectedColor = getColor(at: newValue)
                moveCoursor(at: newValue)
            }
        }
    }
    
    internal var selectedColor: UIColor = .white {
        willSet {
            selectedColorView.backgroundColor = newValue
            brightnessSlider.value = Float(newValue.rgba.alpha)
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
        createGradientLayer()
        
        createTargetImage()
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
    
    private func createGradientLayer() {
        var colorSets = [CGColor]()
        colorSets.append(UIColor.red.cgColor)
        colorSets.append(UIColor.orange.cgColor)
        colorSets.append(UIColor.yellow.cgColor)
        colorSets.append(UIColor.green.cgColor)
        colorSets.append(UIColor.blue.cgColor)
        colorSets.append(UIColor(red: 66.0/255, green: 170.0/255, blue: 255/255, alpha: 1).cgColor)
        colorSets.append(UIColor(red: 139.0/255, green: 0/255, blue: 255/255, alpha: 1).cgColor)
        colorSets.append(UIColor.white.cgColor)
        colorSets.append(UIColor.black.cgColor)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = colorPickerFrame.bounds
        gradientLayer.colors = colorSets
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        colorPickerFrame.layer.addSublayer(gradientLayer)
    }
    
    private func createTargetImage() {
        targetImageView = UIImageView(image: UIImage(named: "target"))
        
        targetImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        targetImageView.isHidden = true
        
        colorPickerFrame.addSubview(targetImageView)
    }
    
    internal func rotateGradient() {
        colorPickerFrame.alpha = 0
        gradientLayer.frame = colorPickerFrame.bounds
        targetImageView.isHidden = true
        
        UIView.animate(withDuration: 0.7) {
            self.colorPickerFrame.alpha = 1
        }
    }
    
    private func getColor(at point: CGPoint) -> UIColor{
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return UIColor.white
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
        guard let slider = brightnessSlider else {
            return color
        }
        
        return color.withAlphaComponent(CGFloat(slider.value))
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.colorPicker(self, willSelectColor: selectedColor)
    }
    
    @IBAction func brightnessSliderChanged(_ sender: UISlider) {
        selectedColor = selectedColor.withAlphaComponent(CGFloat(sender.value))
    }
    
    private func moveCoursor(at point: CGPoint) {
        targetImageView.isHidden = false
        targetImageView.frame.origin.x = point.x - targetImageView.frame.width / 2
        targetImageView.frame.origin.y = point.y - targetImageView.frame.height / 2
    }
}

internal protocol ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPicker, willSelectColor color: UIColor)
}
