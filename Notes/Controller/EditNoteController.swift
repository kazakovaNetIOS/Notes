//
//  EditNoteController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class EditNoteController: UIViewController {
    
    @IBOutlet weak var editNote: EditNote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNote.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let paletteVC = segue.destination as? ColorPickerController  else { return }
        
        paletteVC.delegate = self
    }
}

// MARK: - EditNoteColorPickerTileDelegate
extension EditNoteController: EditNoteColorPickerTileDelegate {
    func editNoteColorPickerTileDidLongPress(_ editNote: EditNote) {
        performSegue(withIdentifier: "goToPalette", sender: self)
    }
}

// MARK: - PalleteDelegate
extension EditNoteController: ColorPickerViewDelegate {
    func colorPickerView(_ paletteVC: ColorPickerController, willSelectColor color: UIColor) {
        editNote.colorPickerTile.image = nil
        editNote.colorPickerTile.backgroundColor = color
        editNote.showCheckIcon(tag: 4)
    }
}

