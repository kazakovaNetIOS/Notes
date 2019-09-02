//
//  ImageConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 27/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ImageConfigurator {
    init(imageIndex: Int, galleryManager: GalleryManager)
    func configure(imageController: ImageViewController)
}

class ImageConfiguratorImpl {
    
    private var imageIndex: Int
    private var galleryManager: GalleryManager
    
    required init(imageIndex: Int, galleryManager: GalleryManager) {
        self.imageIndex = imageIndex
        self.galleryManager = galleryManager
    }
}

//MARK: - ImageConfigurator
/***************************************************************/

extension ImageConfiguratorImpl: ImageConfigurator {
    func configure(imageController: ImageViewController) {
        let presenter = ImagePresenterImpl(view: imageController, imageIndex: imageIndex, manager: galleryManager)
        
        imageController.presenter = presenter
    }
}
