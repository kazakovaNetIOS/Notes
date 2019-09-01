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
    static var container: NSPersistentContainer!
    private var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        // Logger options
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        createContainer { container in
            AppDelegate.container = container
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            let appCoordinator = AppCoordinator(window: window,
                                                notesManager: NotesManager(
                                                    context: container.newBackgroundContext()))
            
            self.window = window
            self.appCoordinator = appCoordinator
            
            appCoordinator.start()
        }
        
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
