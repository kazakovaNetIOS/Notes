//
//  Gist.swift
//  Notes
//
//  Created by Natalia Kazakova on 09/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

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
