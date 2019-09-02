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
    
    init(manager: GalleryManager, view: GalleryView)
    
    func configure(cell: GalleryCell, forRow row: Int)
    func didFinishPickingMediaWithInfo(path: String)
    func didSelectItemAt(row: Int)
    func addImageButtonTapped()
}

protocol GalleryPresenterDelegate: class {
    func presentImage(for imageIndex: Int)
    func presentImagePicker()
    func dismissImagePicker()
}

class GalleryPresenterImpl {
    
    private var manager: GalleryManager
    private weak var view: GalleryView?
    weak var delegate: GalleryPresenterDelegate?
    public var imageCount: Int {
        return manager.imageNames.count
    }
    
    required init(
        manager: GalleryManager,
        view: GalleryView) {
        self.manager = manager
        self.view = view
    }
}

//MARK: - GalleryPresenter
/***************************************************************/

extension GalleryPresenterImpl: GalleryPresenter {
    func addImageButtonTapped() {
        delegate?.presentImagePicker()
    }
    
    func didSelectItemAt(row: Int) {
        delegate?.presentImage(for: row)
    }
    
    func didFinishPickingMediaWithInfo(path: String) {
        manager.append(path: path)
        delegate?.dismissImagePicker()
        view?.refreshGalleryView()
    }
    
    func configure(cell: GalleryCell, forRow row: Int) {
        cell.display(image: manager.imageNames[row])
    }
}
