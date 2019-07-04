//
//  FileNotebook.swift
//  Stepik Notes
//
//  Created by Natalia Kazakova on 21/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {
    public private (set) var notes: [Note] = [Note]()
    
    public func add(_ note: Note) {
        if self.notes.firstIndex(where: { $0.uid == note.uid }) != nil {
            DDLogWarn("Note already exist")
            
            return
        }
        
        self.notes.append(note)
    }
    
    public func remove(with uid: String) {
        if let index = self.notes.firstIndex(where: { $0.uid == uid }){
            self.notes.remove(at: index)
        }
    }
    
    public func saveToFile() {
        guard let fileUrl = getFileNotebookPath() else {
            return
        }
        
        var jsonArrayNotes = [[String: Any]]()
        for note in notes {
            jsonArrayNotes.append(note.json)
        }
        
        do {
            let jsdata = try JSONSerialization.data(withJSONObject: jsonArrayNotes, options: [])
            try jsdata.write(to: fileUrl)
        } catch {
            DDLogError("Error save notes to file, \(error)")
        }
    }
    
    public func loadFromFile() {
        guard let fileUrl = getFileNotebookPath() else {
            return
        }
        
        do {
            guard let jsData = try String(contentsOf: fileUrl).data(using: .utf8) else { return }
            
            let anyJsonObject = try JSONSerialization.jsonObject(with: jsData, options: [])
            
            guard let jsonArrayNotes = anyJsonObject as? [[String : Any]] else { return }
            
            for item in jsonArrayNotes {
                if let note = Note.parse(json: item) {
                    add(note)
                }
            }
        } catch {
            DDLogError("Error reading data from a file, \(error)")
        }
    }
    
    private func getFileNotebookPath() -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var isDir: ObjCBool = false
        let dirUrl = path.appendingPathComponent("notebooks")
        
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                DDLogError("Error creating directory \"notebooks\", \(error)")
                return nil
            }
        }
        
        let fileUrl = dirUrl.appendingPathComponent("Filenotebook")
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        
        return fileUrl
    }
}

