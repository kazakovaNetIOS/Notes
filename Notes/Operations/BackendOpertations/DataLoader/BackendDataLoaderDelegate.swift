//
//  BackendDataLoaderDelegate.swift
//  Notes
//
//  Created by Natalia Kazakova on 10/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol BackendDataLoaderDelegate {
    func process(result: LoadNotesBackendResult)
}
