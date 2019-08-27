//
//  GalleryManager.swift
//  Notes
//
//  Created by Natalia Kazakova on 27/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class GalleryManager {
    public private(set) var imageNames: [String] = ["photo00001",
                                                    "photo00002",
                                                    "photo00003",
                                                    "photo00004",
                                                    "photo00005",
                                                    "photo00006",
                                                    "photo00007",
                                                    "photo00008",
                                                    "photo00009",
                                                    "photo00010"]
}

extension GalleryManager {
    public func append(path: String) {
        imageNames.append(path)
    }
}
