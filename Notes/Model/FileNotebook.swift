//
//  FileNotebook.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {

    public private(set) var notes: [Note] = [Note]()
    private var jsonNotes: [[String : Any]] = []
}

//MARK: - Data modification
/***************************************************************/
extension FileNotebook {
    public func add(note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
    
    public func remove(with uid: String) {
        if let index = self.notes.firstIndex(where: { $0.uid == uid }){
            self.notes.remove(at: index)
        }
    }
}

//MARK: - File storage
/***************************************************************/

extension FileNotebook {
    public func loadFromFile() {
        guard let fileUrl = getFileNotebookPath() else {
            return
        }
        
        do {
            let jsData = try Data(contentsOf: fileUrl)
            let anyJsonObject = try JSONSerialization.jsonObject(with: jsData, options: [])
            
            guard let jsonArrayNotes = anyJsonObject as? [[String : Any]] else { return }
            
            notes = []
            
            for item in jsonArrayNotes {
                if let note = Note.parse(json: item) {
                    add(note: note)
                }
            }
        } catch {
            DDLogError("Error reading data from a file, \(error)")
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
}

//MARK: - Gist storage
/***************************************************************/

extension FileNotebook {
    public static func toJsonString(notes: [Note]) -> String? {
        var json = [[String: Any]]()
        for note in notes {
            json.append(note.json)
        }
        
        do {
            let jsdata = try JSONSerialization.data(withJSONObject: json, options: [])
            return String(data: jsdata, encoding: .utf8)
        } catch {
            DDLogError("Error save notes to file, \(error)")
        }
        return nil
    }
    
    public static func parseNotes(from data: Data) throws -> [Note]? {
        let anyJsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonArrayNotes = anyJsonObject as? [[String : Any]] else { return nil }

        var result = [Note]()
        for item in jsonArrayNotes {
            if let note = Note.parse(json: item) {
                result.append(note)
            }
        }
        
        return result
    }
    
    public static func toGist(notes: [Note]) -> Gist{
        let file = GistFile(content: toJsonString(notes: notes))
        
        return Gist(id: GithubManager.shared.gistId ?? "",
                        description: GithubManager.Constants.gistFileName,
                        isPublic: false,
                        files: [GithubManager.Constants.gistFileName: file])
    }
}

//MARK: - Support methods
/***************************************************************/

extension FileNotebook {
    public func getFileNotebookPath() -> URL? {
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
