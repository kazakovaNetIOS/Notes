//
//  ViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EditNoteProtocol {
    func performSegueFromView() {
        performSegue(withIdentifier: "goToPallete", sender: self)
    }
    

    @IBOutlet weak var editNote: EditNote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        editNote.delegate = self
    }
}

