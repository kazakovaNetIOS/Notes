//
//  Edit Note.swift
//  Notes
//
//  Created by Natalia Kazakova on 04/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

@IBDesignable
class EditNoteView: UIView {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var colorViewsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstColorTile: UIButton!
    @IBOutlet weak var secondColorTile: UIButton!
    @IBOutlet weak var thirdColorTile: UIButton!
    @IBOutlet weak var colorPickerTile: UIImageView!
    
    @IBOutlet weak var firstCheck: CheckIcon!
    @IBOutlet weak var secondCheck: CheckIcon!
    @IBOutlet weak var thirdCheck: CheckIcon!
    @IBOutlet weak var colorPickerCheck: CheckIcon!
    
    var delegate: EditNoteColorPickerTileDelegate?
    var displayNote: Note?
    var editedNote: Note? {
        get {
            guard let note = displayNote else {
                return nil
            }
            
            if !isColorChanged {
                selectedColor = firstColorTile.backgroundColor!
            }
            
            return Note(uid: note.uid,
                        title: titleTextField.text ?? "",
                        content: textTextView.text,
                        color: selectedColor,
                        importance: note.importance,
                        dateOfSelfDestruction: getDateOfSelfDestruction())
        }
    }
    var selectedColor: UIColor = .white
    var isColorChanged: Bool = false
    
    convenience init(frame: CGRect, displayNote: Note?) {
        self.init(frame: frame)
        
        self.displayNote = displayNote
        
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func switchDestroyDateUse(_ sender: UISwitch) {
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
    
    func showCheckIcon(tag: Int) {
        switch tag {
        case 1:
            firstCheck.isHidden = false
            secondCheck.isHidden = true
            thirdCheck.isHidden = true
            colorPickerCheck.isHidden = true
        case 2:
            firstCheck.isHidden = true
            secondCheck.isHidden = false
            thirdCheck.isHidden = true
            colorPickerCheck.isHidden = true
        case 3:
            firstCheck.isHidden = true
            secondCheck.isHidden = true
            thirdCheck.isHidden = false
            colorPickerCheck.isHidden = true
        default:
            firstCheck.isHidden = true
            secondCheck.isHidden = true
            thirdCheck.isHidden = true
            colorPickerCheck.isHidden = false
        }
    }
    
    @objc private func keyboardWillShowOrHide(_ notification: Notification) {
        let keyBoard = notification.userInfo
        
        if let keyboardFrame = keyBoard?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            UIView.animate(withDuration: 1.0, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            })
        }
    }
    
    private func getDateOfSelfDestruction() -> Date? {
        if destroyDateSwitch.isOn {
            return destroyDatePicker.date
        } else {
            return nil
        }
    }
}

//MARK: Setup views
extension EditNoteView {
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EditNoteView", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
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
        
        setBorder(for: titleTextField, color: UIColor.gray.withAlphaComponent(0.2), radius: 5)
        titleTextField.text = displayNote?.title
        
        setBorder(for: textTextView, color: UIColor.gray.withAlphaComponent(0.3), radius: 5)
        textTextView.text = displayNote?.content
        
        firstColorTile.backgroundColor = displayNote?.color
        
        if let dateOfSelfDestruction = displayNote?.dateOfSelfDestruction {
            destroyDateSwitch.isOn = true
            switchDestroyDateUse(destroyDateSwitch)
            destroyDatePicker.date = dateOfSelfDestruction
        }
        
        setBorder(for: firstColorTile, color: .black, radius: 10)
        setBorder(for: secondColorTile, color: .black, radius: 10)
        setBorder(for: thirdColorTile, color: .black, radius: 10)
        setBorder(for: colorPickerTile, color: .black, radius: 10)
    }
    
    private func setBorder(for view: UIView, color: UIColor, radius: CGFloat) {
        view.layer.borderWidth = 1
        view.layer.borderColor = color.cgColor
        view.layer.cornerRadius = radius
    }
}

//MARK: IBAction
extension EditNoteView {
    @IBAction func destroyDateSwitchChanged(_ sender: UISwitch) {
        switchDestroyDateUse(sender)
    }
    
    @IBAction func colorTileTapped(_ sender: UIButton) {
        showCheckIcon(tag: sender.tag)
        
        selectedColor = sender.backgroundColor!
        isColorChanged = true
    }
    
    @IBAction func colorPickerLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.editNoteColorPickerTileDidLongPress(self)
        }
    }
}

//MARK: EditNoteColorPickerTileDelegate
protocol EditNoteColorPickerTileDelegate {
    func editNoteColorPickerTileDidLongPress(_ editNote: EditNoteView)
}

//MARK: class CheckIcon
@IBDesignable
class CheckIcon: UIView { 
    
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var strokeWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let newRect = CGRect(x: 2.0, y: 2.0, width: rect.width - 4, height: rect.height - 4)
        
        let path = UIBezierPath(ovalIn: newRect)
        path.lineWidth = strokeWidth
        
        UIColor.white.setFill()
        strokeColor.setStroke()
        
        path.fill()
        path.stroke()
        
        let checkPath = UIBezierPath()
        checkPath.lineWidth = strokeWidth
        
        checkPath.move(to: CGPoint(x: newRect.width / 2 - 1, y: newRect.height / 2 + 1))
        checkPath.addLine(to: CGPoint(x: newRect.width / 2 + 1, y: newRect.height + newRect.height / 4 - 3))
        checkPath.addLine(to: CGPoint(x: newRect.width + 1, y: 1))
        
        checkPath.stroke()
    }
}
