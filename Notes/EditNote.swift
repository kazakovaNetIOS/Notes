//
//  Edit Note.swift
//  Notes
//
//  Created by Natalia Kazakova on 04/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable
class EditNote: UIView {
    
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var colorViews: UIStackView!
    @IBOutlet weak var colorViewsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstColorTile: UIButton!
    @IBOutlet weak var secondColorTile: UIButton!
    @IBOutlet weak var thirdColorTile: UIButton!
    @IBOutlet weak var colorPickerTile: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EditNote", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(xibView)
    }
    
    @IBAction func destroyDateSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.destroyDatePicker.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
                self.colorViewsTopConstraint.constant = 248
                self.destroyDatePicker.alpha = 1
                
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
                self.colorViewsTopConstraint.constant = 16
                self.destroyDatePicker.alpha = 0
                
                self.layoutIfNeeded()
            }, completion: { (value: Bool) in
                self.destroyDatePicker.isHidden = true
            })
        }
    }
    
    @IBAction func colorTileTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func colorPickerTapped(_ sender: UIButton) {
        print("Color picker")
    }
}
