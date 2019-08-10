//
//  BackendDataLoader.swift
//  Notes
//
//  Created by Natalia Kazakova on 10/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol BackendDataLoaderProtocol {
    func load(from url: URL, completion: @escaping (_ data: Data) -> Void)
    func upload(with url: URLRequest, completion: @escaping (_ data: Data, _ responce: URLResponse?) -> Void)
}

class BackendDataLoader {
    
    var loadNotesDelegate: LoadNotesBackendDelegate?
    var saveNotesDelegate: SaveNotesBackendDelegate?
}

//MARK: - BackendDataLoaderProtocol
/***************************************************************/

extension BackendDataLoader: BackendDataLoaderProtocol {
    func upload(with request: URLRequest, completion: @escaping (Data, URLResponse?) -> Void) {
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.saveNotesDelegate?.process(result: .failure(.unreachable))
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.saveNotesDelegate?.process(result: .failure(.unreachable))
                return
            }
            
            completion(data, response)
            }.resume()
    }
    
    func load(from url: URL, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.loadNotesDelegate?.process(result: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.loadNotesDelegate?.process(result: .notFound)
                return
            }
            
            completion(data)
            }.resume()
    }
}
