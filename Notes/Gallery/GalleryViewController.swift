//
//  GalleryViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

private let reuseIdentifier = "gallery cell"

class GalleryViewController: UICollectionViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCell
    
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
    
        return cell
    }
}
