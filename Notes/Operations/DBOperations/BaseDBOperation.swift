//
//  BaseDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class BaseDBOperation: AsyncOperation {
    
    let notebook: FileNotebook
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
