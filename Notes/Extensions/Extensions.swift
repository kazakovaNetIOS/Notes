//
//  Extensions.swift
//  Notes
//
//  Created by Natalia Kazakova on 19/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

//MARK: - UIColor
/***************************************************************/

extension UIColor {
    var rgba: (red: Float, green: Float, blue: Float, alpha: Float) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (Float(red), Float(green), Float(blue), Float(alpha))
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

//MARK: - StoryboardInstantiable
/***************************************************************/

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype ControllerType: UIViewController
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> ControllerType
}

extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = Self.defaultFileName
        let sb = UIStoryboard(name: fileName, bundle: bundle)
        return sb.instantiateInitialViewController() as! Self
    }
}
