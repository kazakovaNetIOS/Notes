//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CoreData

class LoadNotesDBOperation: BaseDBOperation {
    
    var result: [Note]?
    
    init(notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        super.init(notebook: notebook)
        CoreDataManager.shared.backgroundContext = backgroundContext
        CoreDataManager.shared.delegate = self
    }
    
    override func main() {
        CoreDataManager.shared.fetchNotes()
    }
}

//MARK: - CoreDataManagerDelegate
/***************************************************************/

extension LoadNotesDBOperation: CoreDataManagerDelegate {
    func process(result: CoreDataManagerResult) {
        switch result {
        case .successLoad(let notes):
            self.result = notes
        case .error(let error):
            DDLogError(error)
            self.result = []
        case .successDelete:
            break
        case .successSave:
            break
        }
        finish()
    }
}
