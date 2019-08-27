//
//  GalleryPresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 26/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

protocol GalleryView: class {
    func refreshGalleryView()
}

protocol GalleryCellView {
    func display(image: String)
}

protocol GalleryPresenter {
    var imageCount: Int { get }
    var router: GalleryRouter { get }
    init(manager: GalleryManager, view: GalleryView, router: GalleryRouter)
    func configure(cell: GalleryCell, forRow row: Int)
    func didFinishPickingMediaWithInfo(path: String)
    func didSelectItemAt(row: Int)
    func addImageButtonTapped()
}

class GalleryPresenterImpl {
    
    private var manager: GalleryManager
    private weak var view: GalleryView?
    private(set) var router: GalleryRouter
    public var imageCount: Int {
        return manager.imageNames.count
    }
    
    required init(
        manager: GalleryManager,
        view: GalleryView,
        router: GalleryRouter) {
        self.manager = manager
        self.view = view
        self.router = router
    }
}

//MARK: - GalleryPresenter
/***************************************************************/

extension GalleryPresenterImpl: GalleryPresenter {
    func addImageButtonTapped() {
        router.presentImagePicker()
    }
    
    func didSelectItemAt(row: Int) {
        router.presentImage(for: manager.imageNames[row])
    }
    
    func didFinishPickingMediaWithInfo(path: String) {
        manager.append(path: path)
        router.dismissImagePicker()
        view?.refreshGalleryView()
    }
    
    func configure(cell: GalleryCell, forRow row: Int) {
        cell.display(image: manager.imageNames[row])
    }
}
