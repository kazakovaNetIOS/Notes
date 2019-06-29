//
//  NoteExtensionsTestCase.swift
//  NotesTests
//
//  Created by Natalia Kazakova on 29/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import XCTest
@testable import Notes

class NoteExtensionsTestCase: XCTestCase {

    func testJsonCreated() {
        let date = Date()
        let note = Note(uid: "1", title: "title", content: "content", color: .red, importance: .unimportant, dateOfSelfDestruction: date)
        var json = note.json
        
        XCTAssertEqual(json["uid"] as! String, "1")
        XCTAssertEqual(json["title"] as! String, "title")
        XCTAssertEqual(json["content"] as! String, "content")
        XCTAssertEqual((json["color"] as! Dictionary<String, CGFloat>)["red"], 1.0)
        XCTAssertEqual(json["importance"] as! String, Importance.unimportant.rawValue)
        XCTAssertEqual(json["dateOfSelfDestruction"] as! TimeInterval, date.timeIntervalSince1970)
    }
    
    func testJsonCorrectlyCreated() {
        let note = Note(uid: "1", title: "title", content: "content", color: .white, importance: .ordinary, dateOfSelfDestruction: nil)
        var json = note.json
        
        XCTAssertNil(json["color"])
        XCTAssertNil(json["importance"])
        XCTAssertNil(json["dateOfSelfDestruction"])
    }
    
    func testNoteParsed() {
        let date = Date()
        let json: [String : Any] = ["uid": "1", "title": "title", "content": "content", "color": ["red": CGFloat(1.0), "green": CGFloat(0), "blue": CGFloat(0), "alpha": CGFloat(1.0)], "importance": "unimportant", "dateOfSelfDestruction": date.timeIntervalSince1970]
        
        let parsedNote = Note.parse(json: json)
        
        XCTAssertNotNil(parsedNote)
        XCTAssertEqual(parsedNote!.uid, "1")
        XCTAssertEqual(parsedNote!.title, "title")
        XCTAssertEqual(parsedNote!.content, "content")
        XCTAssertEqual(parsedNote!.color, .red)
        XCTAssertEqual(parsedNote!.importance, .unimportant)
        XCTAssertEqual(parsedNote!.dateOfSelfDestruction?.timeIntervalSince1970, date.timeIntervalSince1970)
    }
    
    func testNoteCorrectlyParsed() {    
        XCTAssertNil(Note.parse(json: [String : Any]())) // empty json
        
        XCTAssertNil(Note.parse(json: ["title": "", "content": ""])) // not uid
        XCTAssertNil(Note.parse(json: ["uid": "", "content": ""])) // not title
        XCTAssertNil(Note.parse(json: ["uid": "", "title": ""])) // not content
        
        XCTAssertNil(Note.parse(json: ["uid": "", "title": "", "content": ""])) // uid is empty
        
        XCTAssertNotNil(Note.parse(json: ["uid": "1", "title": "", "content": ""])) // not unimportant fields
        
        XCTAssertNil(Note.parse(json: ["uid": 1, "title": "", "content": "", "importance": "ordinary", "color": [String : CGFloat](), "dateOfSelfDestruction": TimeInterval()])) // invalid type uid
        XCTAssertNil(Note.parse(json: ["uid": "1", "title": 123, "content": "", "importance": "ordinary", "color": ["red": CGFloat(1.0), "green": CGFloat(1.0), "blue": CGFloat(1.0), "alpha": CGFloat(1.0)], "dateOfSelfDestruction": TimeInterval()])) // invalid type title
        XCTAssertNil(Note.parse(json: ["uid": "1", "title": "", "content": 123, "importance": "ordinary", "color": ["red": CGFloat(1.0), "green": CGFloat(1.0), "blue": CGFloat(1.0), "alpha": CGFloat(1.0)], "dateOfSelfDestruction": TimeInterval()])) // invalid type content
        XCTAssertNil(Note.parse(json: ["uid": "1", "title": "", "content": "", "importance": 123, "color": ["red": CGFloat(1.0), "green": CGFloat(1.0), "blue": CGFloat(1.0), "alpha": CGFloat(1.0)], "dateOfSelfDestruction": TimeInterval()])) // invalid type importance
        XCTAssertNil(Note.parse(json: ["uid": "1", "title": "", "content": "", "importance": "ordinary", "color": 123, "dateOfSelfDestruction": TimeInterval()])) // invalid type color
        XCTAssertNil(Note.parse(json: ["uid": "1", "title": "", "content": "", "importance": "ordinary", "color": ["red": CGFloat(1.0), "green": CGFloat(1.0), "blue": CGFloat(1.0), "alpha": CGFloat(1.0)], "dateOfSelfDestruction": ""])) // invalid type dateOfSelfDestruction
    }
}
