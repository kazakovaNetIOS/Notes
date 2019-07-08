//
//  CheckIcon.swift
//  Notes
//
//  Created by Natalia Kazakova on 07/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable
class CheckIcon: UIView {

    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var strokeWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let newRect = CGRect(x: 2.0, y: 2.0, width: rect.width - 4, height: rect.height - 4)
        
        let path = UIBezierPath(ovalIn: newRect)
        path.lineWidth = strokeWidth
        
        UIColor.white.setFill()
        strokeColor.setStroke()
        
        path.fill()
        path.stroke()
        
        let checkPath = UIBezierPath()
        checkPath.lineWidth = strokeWidth
        checkPath.move(to: CGPoint(x: newRect.width / 2 - 1, y: newRect.height / 2 + 1))
        checkPath.addLine(to: CGPoint(x: newRect.width / 2 + 1, y: newRect.height + newRect.height / 4 - 3))
        checkPath.addLine(to: CGPoint(x: newRect.width + 1, y: 1))
        checkPath.stroke()
    }

}
