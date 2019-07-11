//
//  PaletteView.swift
//  Notes
//
//  Created by Natalia Kazakova on 11/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

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

    public func getColor(at point: CGPoint) -> UIColor{
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
        return color.withAlphaComponent(brightness)
    }
    
    public func rotate() {
        gradientLayer.frame = bounds
    }
}
