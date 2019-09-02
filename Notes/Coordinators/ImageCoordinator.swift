//
//  ImageCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 02/09/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ImageCoordinator {
    
    private let presenter: UINavigationController
    private var imageViewController: ImageViewController?
    private var galleryManager: GalleryManager
    private let imageIndex: Int
    
    init(presenter: UINavigationController,
         galleryManager: GalleryManager,
         imageIndex: Int) {
        self.presenter = presenter
        self.galleryManager = galleryManager
        self.imageIndex = imageIndex
    }
}

//MARK: - Coordinator
/***************************************************************/

extension ImageCoordinator: Coordinator {
    func start() {
        let imageViewController = ImageViewController.instantiateViewController()
        imageViewController.configurator = ImageConfiguratorImpl(imageIndex: imageIndex, galleryManager: galleryManager)
        self.imageViewController = imageViewController
        presenter.pushViewController(imageViewController, animated: true)
    }
}
