//
//  Gist.swift
//  Notes
//
//  Created by Natalia Kazakova on 09/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

typealias GistList = [Gist]

struct Gist {
    let description: String
    let isPublic: Bool
    let files: [String: GistFile]
}

//MARK: - Gist Codable
/***************************************************************/

extension Gist: Codable {
    enum CodingKeys: String, CodingKey {
        case description
        case isPublic = "public"
        case files
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(files, forKey: .files)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = ""
        isPublic = false
        files = try container.decode([String: GistFile].self, forKey: .files)
    }
}

//MARK: - Get URL for gist
/***************************************************************/

extension Gist {
    func getUrl(for gistFileName: String) -> String? {
        guard let file = self.files[gistFileName] else { return nil }
        return file.rawUrl
    }
}

//MARK: - Filtering list
/***************************************************************/

extension GistList {
    func filter(by gistFileName: String) -> Gist? {
        let filteredList = self.filter { (gist) -> Bool in
            return gist.files.filter({ (arg0) -> Bool in
                let (fileName, _) = arg0
                return fileName == gistFileName
            }).count > 0
        }
        guard filteredList.count > 0 else { return nil }
        return filteredList[0]
    }
}

//MARK: - Get URL by file name
/***************************************************************/

extension GistList {
    func getGistUrl(by gistFileName: String)  -> String? {
        guard let gistWithNotebook = self.filter(by: gistFileName),
            let url = gistWithNotebook.getUrl(for: gistFileName) else {
                return nil
        }
        
        return url
    }
}
