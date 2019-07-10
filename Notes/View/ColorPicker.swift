//
//  ColorPickerView.swift
//  Notes
//
//  Created by Natalia Kazakova on 08/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPicker: UIView {
    
    weak internal var delegate: ColorPickerDelegate?
    
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3
    
    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        self.clipsToBounds = true
        
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        
        self.addGestureRecognizer(touchGesture)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizer.State.began) {
            let point = gestureRecognizer.location(in: self)
            let color = getColorAtPoint(point: point)
            
            drawPickDot(in: point)
            
            self.delegate?.colorPickerTouched(sender: self, color: color, point: point, state: gestureRecognizer.state)
        }
    }
    
    func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                                   y: elementSize * CGFloat(Int(point.y / elementSize)))
        
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        
        let hue = roundedPoint.x / self.bounds.width
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func drawPickDot(in point: CGPoint) {
        let rect = CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        
        UIColor.black.setStroke()
        path.lineWidth = 1
        path.stroke()
        
        print("dot")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        for y : CGFloat in stride(from: 0.0, to: rect.height, by: self.elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? self.saturationExponentTop : self.saturationExponentBottom))
            
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x : CGFloat in stride(from: 0.0, to: rect.width, by: self.elementSize) {
                let hue = x / rect.width
                
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context.setFillColor(color.cgColor)
                context.fill(
                    CGRect(
                        x: x,
                        y: y,
                        width: self.elementSize,
                        height: self.elementSize
                ))
            }
        }
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos: CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }
}

internal protocol ColorPickerDelegate: NSObjectProtocol {
    func colorPickerTouched(sender: ColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State)
}
