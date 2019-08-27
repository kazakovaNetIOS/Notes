//
//  ImageConfigurator.swift
//  Notes
//
//  Created by Natalia Kazakova on 27/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol ImageConfigurator {
    init(imageIndex: Int)
    func configure(imageController: ImageViewController)
}

class ImageConfiguratorImpl {
    
    private var imageIndex: Int
    
    required init(imageIndex: Int) {
        self.imageIndex = imageIndex
    }
}

//MARK: - ImageConfigurator
/***************************************************************/

extension ImageConfiguratorImpl: ImageConfigurator {
    func configure(imageController: ImageViewController) {
        let presenter = ImagePresenterImpl(view: imageController, imageIndex: imageIndex, manager: GalleryManager())
        
        imageController.presenter = presenter
    }
}
