//
//  GalleryCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 02/09/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class GalleryCoordinator {
    
    private let presenter: UINavigationController
    private var galleryViewController: GalleryViewController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
}

//MARK: - Coordinator
/***************************************************************/

extension GalleryCoordinator: Coordinator {
    func start() {
        let galleryViewController = GalleryViewController.instantiateViewController()
        galleryViewController.configurator = GalleryConfiguratorImpl()
        self.galleryViewController = galleryViewController
        presenter.pushViewController(galleryViewController, animated: true)
    }
}
