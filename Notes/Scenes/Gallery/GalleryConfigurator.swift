//
//  GalleryConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 26/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol GalleryConfigurator {
    func configure(galleryViewController: GalleryViewController)
    init(galleryManager: GalleryManager, galleryPresenterDelegate: GalleryPresenterDelegate)
}

class GalleryConfiguratorImpl {
    
    var galleryManager: GalleryManager
    var galleryPresenterDelegate: GalleryPresenterDelegate
    
    required init(galleryManager: GalleryManager, galleryPresenterDelegate: GalleryPresenterDelegate) {
        self.galleryManager = galleryManager
        self.galleryPresenterDelegate = galleryPresenterDelegate
    }
}

//MARK: - GalleryConfigurator
/***************************************************************/

extension GalleryConfiguratorImpl: GalleryConfigurator {
    func configure(galleryViewController: GalleryViewController) {
        let presenter = GalleryPresenterImpl(manager: galleryManager, view: galleryViewController)
        presenter.delegate = galleryPresenterDelegate
        galleryViewController.presenter = presenter
    }
}
