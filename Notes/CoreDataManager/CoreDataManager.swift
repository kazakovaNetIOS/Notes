//
//  CoreDataManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 20/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CoreData


protocol CoreDataManagerDelegate {
    func process(result: CoreDataManagerResult)
}

enum CoreDataManagerResult {
    case successLoad([Note])
    case error(String)
}

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    public var delegate: CoreDataManagerDelegate?
    public var backgroundContext: NSManagedObjectContext!
    
    private init() {
    }
}

//MARK: - <#text#>
/***************************************************************/

extension CoreDataManager {
    func fetchData() {
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        
        backgroundContext.performAndWait {
            do {
                let moNotes: [NoteMO] = try backgroundContext.fetch(request)
                var result = [Note]()
                
                for moNote in moNotes {
                    result.append(Note(uid: moNote.uid ?? UUID().uuidString,
                                        title: moNote.title ?? "",
                                        content: moNote.content ?? "",
                                        color: moNote.color as? UIColor ?? UIColor.white,
                                        importance: Importance(rawValue: moNote.importance ?? Importance.ordinary.rawValue) ?? Importance.ordinary,
                                        dateOfSelfDestruction: moNote.dateOfSelfDestruction))
                }
                
                delegate?.process(result: .successLoad(result))
            } catch {
                delegate?.process(result: .error(error.localizedDescription))
            }
        }
    }
}
