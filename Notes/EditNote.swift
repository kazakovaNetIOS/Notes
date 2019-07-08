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
    
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var colorViewsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstColorTile: UIButton!
    @IBOutlet weak var secondColorTile: UIButton!
    @IBOutlet weak var thirdColorTile: UIButton!
    @IBOutlet weak var colorPickerTile: UIImageView!
    
    @IBOutlet weak var firstCheck: CheckIcon!
    @IBOutlet weak var secondCheck: CheckIcon!
    @IBOutlet weak var thirdCheck: CheckIcon!
    
    var delegate: EditNoteProtocol?
    
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowOrHide),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowOrHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        setBorder(for: firstColorTile)
        setBorder(for: secondColorTile)
        setBorder(for: thirdColorTile)
        setBorder(for: colorPickerTile)
    }
    
    private func setBorder(for view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
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
    
    fileprivate func showCheckIcon(tag: Int) {
        if tag == 1 {
            firstCheck.isHidden = false
            secondCheck.isHidden = true
            thirdCheck.isHidden = true
        } else if tag == 2 {
            firstCheck.isHidden = true
            secondCheck.isHidden = false
            thirdCheck.isHidden = true
        } else if tag == 3 {
            firstCheck.isHidden = true
            secondCheck.isHidden = true
            thirdCheck.isHidden = false
        }
    }
    
    @IBAction func colorTileTapped(_ sender: UIButton) {
        showCheckIcon(tag: sender.tag)
    }
    
    
    @IBAction func colorPickerLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
        delegate?.performSegueFromView()
        }
    }
    
    
    @objc func keyboardWillShowOrHide(_ notification: Notification) {
        let keyBoard = notification.userInfo
        
        if let keyboardFrame = keyBoard?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            UIView.animate(withDuration: 1.0, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            })
        }
    }
}

protocol EditNoteProtocol {
    func performSegueFromView()
}
