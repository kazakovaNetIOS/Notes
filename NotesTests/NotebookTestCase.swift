//
//  NotebookTestCase.swift
//  NotesTests
//
//  Created by Natalia Kazakova on 29/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import XCTest
@testable import Notes

class NotebookTestCase: XCTestCase {
    
    var notebook: FileNotebook!
    var note: Note!

    override func setUp() {
        super.setUp()
        
        notebook = FileNotebook()
        note = Note(uid: "1", title: "title", content: "content", color: .white, importance: .ordinary, dateOfSelfDestruction: Date())
    }

    override func tearDown() {
        notebook = nil
        note = nil
    }
    
    func testNoteAdded() {
        notebook.add(note)
        
        XCTAssertGreaterThan(notebook.notes.count, 0)
    }
    
    func testDouleNoteNotAdded() {
        let noteDouble = Note(uid: "1", title: "title", content: "content", color: .white, importance: .ordinary, dateOfSelfDestruction: Date())
        
        notebook.add(note)
        notebook.add(noteDouble)
        
        XCTAssertEqual(notebook.notes.count, 1)
    }
    
    func testNoteRemoved() {
        notebook.add(note)
        
        notebook.remove(with: "2")
        XCTAssertEqual(notebook.notes.count, 1)
        
        notebook.remove(with: "1")
        XCTAssertEqual(notebook.notes.count, 0)
    }
    
    func testNoteSavedToFile() {
        notebook.add(note)
        notebook.saveToFile()
        
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("notebooks").appendingPathComponent("Filenotebook")
        let jsData = try! String(contentsOf: path)
        
        XCTAssertTrue(jsData.contains("\"uid\":\"1\""))
    }
    
    func testNoteLoadFromFile() {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("notebooks").appendingPathComponent("Filenotebook")
        
        
        let jsdata = try! JSONSerialization.data(withJSONObject: [note.json], options: [])
        try! jsdata.write(to: path)
        
        notebook.loadFromFile()
        
        XCTAssertEqual(notebook.notes.count, 1)
        XCTAssertEqual(notebook.notes[0].uid, "1")
    }
    
    func testPathCreated() {
        notebook.saveToFile()
        
        XCTAssertNotNil(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("notebooks").appendingPathComponent("Filenotebook"))
    }
}
