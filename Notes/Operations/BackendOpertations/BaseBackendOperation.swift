//
//  BaseBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum NetworkError {
    case unreachable
}

class BaseBackendOperation: AsyncOperation {
    
    let notebook: FileNotebook
    let gistRepositoryUrl = "https://api.github.com/users/kazakovaNetIOS/gists"
    let gistPostUrl = "https://api.github.com/gists"
    let gistPatchUrl = "https://api.github.com/gists/c1ed3079055c62741fe5d55edc7abe5f"
    let gistFileName = "ios-course-notes-db"
    let token = "f223029b7af7c531f095b555dc00b030af7252bb"
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
