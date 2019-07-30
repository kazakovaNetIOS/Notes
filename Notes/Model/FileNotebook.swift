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
    
    public func add(note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
    
    public func replaceAll(notes: [Note]) {
        self.notes = notes
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
                    add(note: note)
                }
            }
        } catch {
            DDLogError("Error reading data from a file, \(error)")
        }
    }
    
    public func sortNotesByTitle() {
        notes.sort(by: { $0.title < $1.title })
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
    
    public func loadDummyData() {        
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

