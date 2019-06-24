//
//  Note.swift
//  Stepik Notes
//
//  Created by Natalia Kazakova on 18/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let dateOfSelfDestruction: Date?
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = UIColor.white, importance: Importance, dateOfSelfDestruction: Date?) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.dateOfSelfDestruction = dateOfSelfDestruction
    }
}

enum Importance: String {
    case unimportant = "unimportant"
    case ordinary = "ordinary"
    case important = "important"
}
