//
//  GalleryCell.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageContainer.layer.borderColor = UIColor.lightGray.cgColor
        imageContainer.layer.borderWidth = 1
        imageContainer.layer.cornerRadius = 5
    }
}
