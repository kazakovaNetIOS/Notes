//
//  PasswordViewModelType.swift
//  Notes
//
//  Created by Natalia Kazakova on 28/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol PasswordViewModelType {
    var passwordValue: Box<String?> { get }
    var hintValue: Box<String?> { get }
    
    func save() 
}
