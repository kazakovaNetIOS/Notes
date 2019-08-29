//
//  Box.swift
//  Notes
//
//  Created by Natalia Kazakova on 28/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    var value: T {
        didSet {
            print("Set new value: \(value)")
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
