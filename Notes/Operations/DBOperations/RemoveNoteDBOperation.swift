//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let noteId: String
    
    init(noteId: String,
         notebook: FileNotebook) {
        self.noteId = noteId
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: noteId)
        notebook.saveToFile()
        
        DDLogDebug("Remove note from db completed")
        
        finish()
    }
}
