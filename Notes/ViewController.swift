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
        
        let notebook = FileNotebook()
        let note = Note(uid: "1", title: "", content: "", color: .white, importance: .important, dateOfSelfDestruction: nil)
        
        notebook.add(note)
        notebook.add(note)
    }
}

