//
//  GalleryRouter.swift
//  Notes
//
//  Created by Natalia Kazakova on 26/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol GalleryRouter {
    func presentImage(for image: String)
    func presentImagePicker()
    func dismissImagePicker()
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class GalleryRouterImpl {
    
    private weak var galleryViewController: GalleryViewController?
    private var image: String!
    
    init(galleryViewController: GalleryViewController?) {
        self.galleryViewController = galleryViewController
    }
}

//MARK: - GalleryRouter
/***************************************************************/

extension GalleryRouterImpl: GalleryRouter {
    func dismissImagePicker() {
        galleryViewController?.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = galleryViewController
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        galleryViewController?.present(pickerController, animated: true, completion: nil)
    }
    
    func presentImage(for image: String) {
        self.image = image
        galleryViewController?.performSegue(withIdentifier: "goToImage", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImage",
            let imageController = segue.destination as? ImageController {
//            imageController.configurator = EditNoteConfiguratorImpl(note: note,
//                                                               editNotePresenterDelegate: editNotePresenterDelegate)
        }
    }
}
