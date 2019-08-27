//
//  ImagePresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 27/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ImageView {
    
}

protocol ImagePresenter {
    var imageNames: [String] { get }
    var imageIndex: Int { get }
    init(view: ImageView, imageIndex: Int, manager: GalleryManager)
}

class ImagePresenterImpl {
    
    private var view: ImageView
    private var manager: GalleryManager
    var imageIndex: Int
    var imageNames: [String] {
        return manager.imageNames
    }
    
    required init(view: ImageView, imageIndex: Int, manager: GalleryManager) {
        self.view = view
        self.imageIndex = imageIndex
        self.manager = manager
    }
}

//MARK: - ImagePresenter
/***************************************************************/

extension ImagePresenterImpl: ImagePresenter {
    
}
