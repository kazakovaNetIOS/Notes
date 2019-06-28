//
//  ViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createNewNote()
        saveNote()
    }
    
    // MARK: - Stub for creating notes function
    func createNewNote() {
        if getConfigValue("Notes limit") == "0" {
            // Pay version
            print("Pay version createNewNote")
        } else {
            // Free version
            print("Free version createNewNote")
        }
    }
    
    // MARK: - Stub for saving notes function
    func saveNote() {
        if getConfigValue("Use remote data storage") == "YES" {
            // Pay version
            print("Pay version saveNote")
        } else {
            // Free version
            print("Free version saveNote")
        }
    }

    func getConfigValue(_ key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }

}

