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
}

class BackendDataLoader {
    
    var delegate: BackendDataLoaderDelegate
    
    init(delegate: BackendDataLoaderDelegate) {
        self.delegate = delegate
    }
}

//MARK: - BackendDataLoaderProtocol
/***************************************************************/

extension BackendDataLoader: BackendDataLoaderProtocol {
    func load(from url: URL, completion: @escaping (_ data: Data) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            
            guard error == nil else {
                DDLogError("Error: \(error?.localizedDescription ?? "no description")")
                sself.delegate.process(result: .notFound)
                return
            }
            guard let data = data else {
                DDLogError("No data")
                sself.delegate.process(result: .notFound)
                return
            }
            
            completion(data)
            }.resume()
    }
}
