//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success([Note])
    case notFound
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        loadUserGists()
    }
    
    private func loadUserGists() {
        let stringUrl = "https://api.github.com/users/kazakovaNetIOS/gists"
        guard let url = URL(string: stringUrl) else { return }
        
        load(with: url) { [weak self] (data) in
            guard let sself = self else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let gistsList = try decoder.decode([Gist].self, from: data)
                
                sself.loadNotesGistData(gistList: gistsList)
            } catch let error {
                DDLogError("Error while parsing Gist: \(error)")
                sself.finishLoad(with: .notFound)
            }
        }
    }
    
    private func loadNotesGistData(gistList: [Gist]) {
        guard let notesGist = searchNotesGist(from: gistList) else {
            finishLoad(with: .notFound)
            return
        }
        guard let url = getRawUrl(for: notesGist) else {
            finishLoad(with: .notFound)
            return
        }
        loadNotesData(from: url)
    }
    
    private func searchNotesGist(from gistsList: [Gist]) -> Gist? {
        let gist = gistsList.filter { (gist) -> Bool in
            return gist.files.filter({ (arg0) -> Bool in
                let (fileName, _) = arg0
                return fileName == "ios-course-notes-db"
            }).count > 0
        }
        guard gist.count > 0 else { return nil }
        return gist[0]
    }
    
    private func getRawUrl(for gist: Gist) -> String? {
        guard let file = gist.files["ios-course-notes-db"] else { return nil }
        return file.rawUrl
    }
    
    private func loadNotesData(from stringUrl: String) {
        let stringUrl = "https://api.github.com/users/kazakovaNetIOS/gists"
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.finishLoad(with: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.finishLoad(with: .notFound)
                return
            }
            
            let notes = sself.notebook.getNotes(from: data)
            
            sself.finishLoad(with: .success(notes))
            }.resume()
    }
    
    private func finishLoad(with result: LoadNotesBackendResult) {
        self.result = result
        finish()
    }
    
    private func load(with url: URL, completion: @escaping (_ data: Data) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.finishLoad(with: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.finishLoad(with: .notFound)
                return
            }
            
            completion(data)
            }.resume()
    }
}
//
// 1. Загрузить все гисты пользователя
// 2. Перебрать файлы в загруженных гистах чтобы найти файл с нужным именем
// 3. Получить урл на этот файл
// 4. Загрузить содержимое по урлу
