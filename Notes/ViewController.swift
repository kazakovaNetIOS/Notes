//
//  ViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EditNoteProtocol, PalleteProtocol {
    
    @IBOutlet weak var editNote: EditNote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNote.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PalletteViewController
        
        destinationVC.delegate = self
    }
    
    func performSegueFromView() {
        performSegue(withIdentifier: "goToPallete", sender: self)
    }
    
    func onColorSelected(color: UIColor) {
        editNote.colorPickerTile.image = nil
        editNote.colorPickerTile.backgroundColor = color
        editNote.showCheckIcon(tag: 4)
    }
}

