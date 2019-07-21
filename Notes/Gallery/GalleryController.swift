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

class GalleryController: UIViewController {
    
    private let imageNames = ["photo00001",
                              "photo00002",
                              "photo00003",
                              "photo00004",
                              "photo00005",
                              "photo00006",
                              "photo00007",
                              "photo00008",
                              "photo00009",
                              "photo00010"]
    private var selectedImageIndex: Int?
}

//MARK: - Lifecycle methods
extension GalleryController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addImageButtonTapped(_:)))
    }
}

//MARK: - Selector methods
extension GalleryController {
    @objc func addImageButtonTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: "goToImage", sender: self)
    }
}

//MARK: - Collection data source methods
extension GalleryController: UICollectionViewDataSource{
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }
}

//MARK: - Collection view delegate methods
extension GalleryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageIndex = indexPath.row
        
        performSegue(withIdentifier: "goToImage", sender: self)
    }
}

//MARK: - Override methods
extension GalleryController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImage",
            let imageVC = segue.destination as? ImageController {
            imageVC.imageNames = imageNames
            imageVC.selectedImageIndex = selectedImageIndex
        }
    }
}
