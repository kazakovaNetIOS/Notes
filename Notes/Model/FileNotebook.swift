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
    public func toJsonString() -> String? {
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
    
    public func parseNotes(from data: Data) {
        do {
            let anyJsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArrayNotes = anyJsonObject as? [[String : Any]] else { return }

            notes = []
            for item in jsonArrayNotes {
                if let note = Note.parse(json: item) {
                    add(note: note)
                }
            }
        } catch {
            DDLogError("Error while parsing notebook: \(error)")
        }
    }
}

//MARK: - Dummy data
/***************************************************************/

extension FileNotebook {
    private func loadDummyData() {
        notes.append(Note(title: "Л. Толстой", content: "Каждый хочет изменить человечество, но никто не задумывается о том, как изменить себя.", importance: Importance.ordinary, dateOfSelfDestruction: nil))
        notes.append(Note(title: "А. Пушкин", content: "Научить человека быть счастливым — нельзя, но воспитать его так, чтобы он был счастливым, можно.", importance: Importance.important, dateOfSelfDestruction: nil))
        notes.append(Note(title: "С. Есенин", content: "Времени нет. Серьезно? Это желания нет, а время есть всегда.", importance: Importance.ordinary, dateOfSelfDestruction: nil))
        notes.append(Note(title: "В. Маяковский", content: "Красивая женщина — рай для глаз, ад для души и чистилище для кармана.", importance: Importance.unimportant, dateOfSelfDestruction: nil))
        notes.append(Note(title: "Б. Пастернак", content: "Надо ставить себе задачи выше своих сил: во-первых, потому, что их всё равно никогда не знаешь, а во-вторых, потому, что силы и появляются по мере выполнения недостижимой задачи.", importance: Importance.important, dateOfSelfDestruction: nil))
        notes.append(Note(title: "В. Высоцкий", content: "Я не люблю уверенности сытой, уж лучше пусть откажут тормоза. Досадно мне, коль слово «честь» забыто и коль в чести наветы за глаза.", importance: Importance.unimportant, dateOfSelfDestruction: nil))
        notes.append(Note(title: "Ф. Достоевский", content: "Красота спасет мир.", importance: Importance.important, dateOfSelfDestruction: nil))
        notes.append(Note(title: "М. Лермонтов", content: "Уважения заслуживают те люди, которые независимо от ситуации, времени и места, остаются такими же, какие они есть на самом деле.", importance: Importance.important, dateOfSelfDestruction: nil))
        notes.append(Note(title: "У. Шекспир", content: "Грехи других судить Вы так усердно рвётесь – начните со своих и до чужих не доберётесь.", importance: .important, dateOfSelfDestruction: nil))
        notes.append(Note(title: "М. Булгаков", content: "Я полагаю, что ни в каком учебном заведении образованным человеком стать нельзя. Но во всяком хорошо поставленном учебном заведении можно стать дисциплинированным человеком и приобрести навык, который пригодится в будущем, когда человек вне стен учебного заведения станет образовывать сам себя.", importance: .ordinary, dateOfSelfDestruction: nil))
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
