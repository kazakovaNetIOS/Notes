//
//  AppCoordinator.swift
//  Notes
//
//  Created by Natalia Kazakova on 30/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    let window: UIWindow
    let rootViewController: UITabBarController
    
    let notesCoordinator: Coordinator
    let galleryCoordinator: Coordinator
    
    init(window: UIWindow,
         notesManager: NotesManager) {
        self.window = window
        rootViewController = UITabBarController()
        
        let notesRootController = UINavigationController()
        notesRootController.tabBarItem = UITabBarItem(title: "Заметки",
                                                      image: UIImage(named: "edit"),
                                                      selectedImage: nil)
        
        let galleryRootController = UINavigationController()
        galleryRootController.tabBarItem = UITabBarItem(title: "Галерея",
                                                      image: UIImage(named: "gallery"),
                                                      selectedImage: nil)
        rootViewController.viewControllers = [notesRootController, galleryRootController]
        
        notesCoordinator = NotesCoordinator(presenter: notesRootController,
                                            notesManager: notesManager)
        galleryCoordinator = GalleryCoordinator(presenter: galleryRootController, galleryManager: GalleryManager())
        
    }
}

//MARK: - Coordinator
/***************************************************************/

extension AppCoordinator: Coordinator {
    func start() {
        window.rootViewController = rootViewController
        notesCoordinator.start()
        galleryCoordinator.start()
        window.makeKeyAndVisible()
    }
}
