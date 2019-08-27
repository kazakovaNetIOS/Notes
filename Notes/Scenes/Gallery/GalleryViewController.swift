//
//  GalleryViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack

private let reuseIdentifier = "gallery cell"

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: GalleryPresenter!
}

//MARK: - GalleryView
/***************************************************************/

extension GalleryViewController: GalleryView {
    func refreshGalleryView() {
        collectionView.reloadData()
    }
}

//MARK: - Lifecycle methods
extension GalleryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        GalleryConfiguratorImpl().configure(galleryViewController: self)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - Setup views
/***************************************************************/

extension GalleryViewController {
    private func setupViews() {        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addImageButtonTapped))
    }
}

//MARK: - Selector methods
extension GalleryViewController {
    @objc func addImageButtonTapped(_ sender: UIButton) {
        presenter.addImageButtonTapped()
    }
}

//MARK: - Image picker delegate methods
extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL,
            let path = pickedImageURL.path {
            presenter.didFinishPickingMediaWithInfo(path: path)            
        }
    }
}

//MARK: - Collection data source methods
extension GalleryViewController: UICollectionViewDataSource{
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCell
        presenter?.configure(cell: cell, forRow: indexPath.row)
        
        return cell
    }
}

//MARK: - Collection view delegate methods
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(row: indexPath.row)
    }
}

//MARK: - Override methods
extension GalleryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
}
