//
//  Note.swift
//  Notes
//
//  Created by Natalia Kazakova on 18/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

enum Importance: String, Codable {
    case unimportant = "unimportant"
    case ordinary = "ordinary"
    case important = "important"
}

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

//MARK: - Convert to JSON
/***************************************************************/

extension Note {
    var json: [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = self.uid
        dict["title"] = self.title
        dict["content"] = self.content
        
        if self.color != UIColor.white {
            switch self.color.rgba {
            case (let r, let g, let b, let a):
                dict["color"] = ["red": r, "green": g, "blue": b, "alpha": a]
            }
        }
        
        if self.importance != .ordinary {
            dict["importance"] = self.importance.rawValue
        }
        
        if let date = self.dateOfSelfDestruction {
            dict["dateOfSelfDestruction"] = date.timeIntervalSince1970
        }
        
        return dict
    }
}

//MARK: - Parse from JSON
/***************************************************************/

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        guard json.count != 0,
            json["uid"] != nil,
            json["title"] != nil,
            json["content"] != nil else {
                return nil
        }
        
        var uid: String = ""
        var title: String = ""
        var content: String = ""
        var color: UIColor = UIColor.white
        var importance: Importance = .ordinary
        var dateOfSelfDestruction: Date?
        
        for (key, value) in json {
            switch key {
            case "uid":
                guard let uidString = value as? String, uidString != "" else {
                    return nil
                }
                
                uid = uidString
            case "title":
                guard let titleString = value as? String else {
                    return nil
                }
                
                title = titleString
            case "content":
                guard let contentString = value as? String else {
                    return nil
                }
                
                content = contentString
            case "dateOfSelfDestruction":
                guard let timeInterval = value as? TimeInterval else {
                    return nil
                }
                
                dateOfSelfDestruction = Date(timeIntervalSince1970: timeInterval)
            case "color":
                guard let colorDict = value as? Dictionary<String, CGFloat>,
                    let r = colorDict["red"],
                    let g = colorDict["green"],
                    let b = colorDict["blue"],
                    let a = colorDict["alpha"] else {
                        return nil
                }
                
                color = UIColor(red: r, green: g, blue: b, alpha: a)
            case "importance":
                guard let importanceRawValue = value as? String,
                    let importanceValue = Importance(rawValue: importanceRawValue) else {
                        return nil
                }
                
                importance = importanceValue
            default:
                break
            }
        }
        
        return Note(
            uid: uid,
            title: title,
            content: content,
            color: color,
            importance: importance,
            dateOfSelfDestruction: dateOfSelfDestruction
        )
    }
}
