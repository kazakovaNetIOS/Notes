//
//  AuthManagerDelegate.swift
//  Notes
//
//  Created by Natalia Kazakova on 16/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol AuthManagerDelegate {
    func show(_ authController: UIViewController)
    func authPassed()
}
