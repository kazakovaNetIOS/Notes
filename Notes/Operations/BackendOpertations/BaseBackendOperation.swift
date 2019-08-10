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
    
    let gistPostUrl = "https://api.github.com/gists"
    var gistPatchUrl: String {
        return "https://api.github.com/gists/\(BaseBackendOperation.gistId!)"
    }
    let gistFileName = "ios-course-notes-db"
    let gistRepositoryUrl = "https://api.github.com/users/kazakovaNetIOS/gists"
    
    static var gistId: String?
    let token = "fa1a1f10387008d0ee7d2b6524162c7dd48ada7e"
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
