//
//  ImageViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: ImagePresenter!
    var configurator: ImageConfigurator!
    
    private var imageViews = [UIImageView]()
    private var contentOffset: CGFloat = 0.0
}

//MARK: - ImageView
/***************************************************************/

extension ImageViewController: ImageView {
    
}

extension ImageViewController {
    func setupViews() {
        self.tabBarController?.tabBar.isHidden = true
        
        for name in presenter.imageNames {
            let image = UIImage(named: name)
            let imageView = UIImageView(image: image)
            
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
}

//MARK: - Override methods
/***************************************************************/

extension ImageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(imageController: self)
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
            if index < presenter.imageIndex {
                contentOffset += imageView.frame.width
            }
        }
        
        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth,
                                        height: scrollView.frame.height)
        
        scrollView.contentOffset.x = contentOffset
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        contentOffset = 0
    }
}
