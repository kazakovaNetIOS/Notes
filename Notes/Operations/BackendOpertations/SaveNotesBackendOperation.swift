//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    
    init(notebook: FileNotebook, notes: [Note]) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        result = .failure(.unreachable)
        
        DDLogDebug("Save notes to backend result: \(String(describing: result))")
        
        finish()
    }
}
