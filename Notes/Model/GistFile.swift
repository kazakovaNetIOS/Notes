//
//  GistFile.swift
//  Notes
//
//  Created by Natalia Kazakova on 09/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

struct GistFile {
    let filename: String
    let rawUrl: String
    let content: String?
    
    init(content: String?) {
        self.filename = ""
        self.rawUrl = ""
        self.content = content
    }
}

//MARK: - Codable
/***************************************************************/

extension GistFile: Codable {
    enum CodingKeys: String, CodingKey {
        case filename
        case rawUrl
        case content
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        filename = try container.decode(String.self, forKey: .filename)
        rawUrl = try container.decode(String.self, forKey: .rawUrl)
        content = ""
    }
}
