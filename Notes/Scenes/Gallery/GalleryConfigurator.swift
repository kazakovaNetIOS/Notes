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
}

class GalleryConfiguratorImpl {
    
}

//MARK: - GalleryConfigurator
/***************************************************************/

extension GalleryConfiguratorImpl: GalleryConfigurator {
    func configure(galleryViewController: GalleryViewController) {
        let router = GalleryRouterImpl(galleryViewController: galleryViewController)
        let presenter = GalleryPresenterImpl(manager: GalleryManager(), view: galleryViewController,
                                             router: router)
        galleryViewController.presenter = presenter
    }
}
