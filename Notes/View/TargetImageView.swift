//
//  TargetImageView.swift
//  Notes
//
//  Created by Natalia Kazakova on 11/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

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
