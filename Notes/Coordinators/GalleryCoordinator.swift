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
    private let galleryManager: GalleryManager
    private var galleryViewController: GalleryViewController?
    private var pickerController: UIImagePickerController?
    private var imageCoordinator: ImageCoordinator?
    
    init(presenter: UINavigationController, galleryManager: GalleryManager) {
        self.presenter = presenter
        self.galleryManager = galleryManager
    }
}

//MARK: - Coordinator
/***************************************************************/

extension GalleryCoordinator: Coordinator {
    func start() {
        let galleryViewController = GalleryViewController.instantiateViewController()
        galleryViewController.configurator = GalleryConfiguratorImpl(galleryManager: galleryManager, galleryPresenterDelegate: self)
        self.galleryViewController = galleryViewController
        presenter.pushViewController(galleryViewController, animated: true)
    }
}

//MARK: - GalleryPresenterDelegate
/***************************************************************/

extension GalleryCoordinator: GalleryPresenterDelegate {
    func presentImage(for imageIndex: Int) {
        let imageCoordinator = ImageCoordinator(presenter: presenter, galleryManager: galleryManager, imageIndex: imageIndex)
        imageCoordinator.start()
        self.imageCoordinator = imageCoordinator
    }
    
    func presentImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = galleryViewController
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        galleryViewController?.present(pickerController, animated: true, completion: nil)
        self.pickerController = pickerController
    }
    
    func dismissImagePicker() {
        galleryViewController?.dismiss(animated: true, completion: nil)
    }
}
