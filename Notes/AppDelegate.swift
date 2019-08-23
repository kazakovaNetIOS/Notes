//
//  AppDelegate.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container: NSPersistentContainer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        // Logger options
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        createContainer { container in
            self.container = container
            if let tc = self.window?.rootViewController as? UITabBarController,
                let nc = tc.selectedViewController as? UINavigationController,
                let vc = nc.topViewController as? NotesListController {
                let manager = NotesManager(context: container.newBackgroundContext())
                let presenter = NotesListPresenter(manager: manager, view: vc)
                vc.presenter = presenter
            }
        }
        
//        print(FileNotebook().getFileNotebookPath())
        
        return true
    }
}

//MARK: - Core Data stack
/***************************************************************/

extension AppDelegate {
    func createContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { _, error in
            guard error == nil else {
                fatalError("Failed to load store")
            }
            DispatchQueue.main.async { completion(container) }
        })
    }
}
