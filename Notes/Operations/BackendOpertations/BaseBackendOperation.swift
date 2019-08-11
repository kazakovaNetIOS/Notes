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
    
    var gistPatchUrl: String {
        return "\(gistRepositoryUrl)/\(BaseBackendOperation.gistId!)"
    }
    let gistFileName = "ios-course-notes-db"
    let gistRepositoryUrl = "https://api.github.com/gists"
    
    static var gistId: String?
    static var token: String?
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
