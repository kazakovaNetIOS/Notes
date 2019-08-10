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
    let token = "84083e59d1cdd1190de13f03ee993714612d9596"
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
