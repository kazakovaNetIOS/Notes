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
    @IBOutlet weak var gradientFrame: UIView!
    
    var targetImageView: UIImageView!
    var gradientLayer: CAGradientLayer!
    var delegate: ColorPickerDelegate?
    
    var location: CGPoint = CGPoint(x: 0, y: 0) {
        willSet {
            if location.x > 0 && location.y > 0 {
                selectedColor = getColor(at: newValue)
                moveCoursor(at: newValue)
            }
        }
    }
    
    var selectedColor: UIColor = .white {
        willSet {
            selectedColorView.backgroundColor = newValue
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
    }
    
    func setupViews() {
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
    
    func createGradientLayer() {
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
        gradientLayer.frame = gradientFrame.bounds
        gradientLayer.colors = colorSets
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientFrame.layer.addSublayer(gradientLayer)
        
        targetImageView = UIImageView(image: UIImage(named: "target"))
        targetImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        targetImageView.isHidden = true
        gradientFrame.addSubview(targetImageView)
    }
    
    func getColor(at point: CGPoint) -> UIColor{
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.translateBy(x: -point.x, y: -point.y)
        gradientLayer.render(in: context)
        
        let color = UIColor(red:   CGFloat(pixel[0]) / 255.0,
                            green: CGFloat(pixel[1]) / 255.0,
                            blue:  CGFloat(pixel[2]) / 255.0,
                            alpha: CGFloat(pixel[3]) / 255.0)
        pixel.deallocate()
        
        return getColor(withAlpha: color)
    }
    
    func getColor(withAlpha color: UIColor) -> UIColor {
        guard let slider = brightnessSlider else {
            return color
        }
        
        return color.withAlphaComponent(CGFloat(slider.value))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        location = touch.location(in: gradientFrame)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        location = touch.location(in: gradientFrame)
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

protocol ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPicker, willSelectColor color: UIColor)
}
