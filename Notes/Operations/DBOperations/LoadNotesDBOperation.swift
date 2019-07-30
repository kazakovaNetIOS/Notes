//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    
    var result: [Note]?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        result = notebook.notes
        finish()
    }
}
