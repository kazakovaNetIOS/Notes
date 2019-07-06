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
    @IBOutlet weak var destroyDateSwitchTopConstraint: NSLayoutConstraint!
    
    
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
        self.destroyDatePicker.isHidden = !sender.isOn
//        // FIXME: не работает анимация
//        if sender.isOn {
//            UIView.animate(withDuration: 1) {
//                self.destroyDateSwitchTopConstraint.constant = 248
//            }
//        } else {
//            UIView.animate(withDuration: 1) {
//                self.destroyDateSwitchTopConstraint.constant = 16
//            }
//        }
        
        
    }
}
