//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 24/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
    
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
    
    var configurator: EditNoteConfigurator!
    var presenter: EditNotePresenter!
    
    var selectedColor: UIColor = .white
    var isColorChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(editNoteViewController: self)
        setupViews()
        presenter.viewDidLoad()
    }
}

//MARK: - EditNoteView
/***************************************************************/

extension EditNoteViewController: EditNoteView {
    func showDestroyDatePicker(with date: Date) {
        destroyDatePicker.date = date
        destroyDatePicker.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
            self.colorViewsTopConstraint.constant = 248
            self.destroyDatePicker.alpha = 1
            self.destroyDateSwitch.isOn = true
            
            self.loadViewIfNeeded()
        }, completion: nil)
    }
    
    func hideDestroyDatePicker() {
        self.destroyDateSwitch.isOn = false
        UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
            self.colorViewsTopConstraint.constant = 16
            self.destroyDatePicker.alpha = 0
            self.destroyDatePicker.isHidden = true
            
            self.loadViewIfNeeded()
        }, completion: nil)
    }
    
    func showSelectedColorFromTile(tag: Int) {
        showCheckIcon(tag: tag)
    }
    
    func resetColorTilesState() {
        firstColorTile.backgroundColor = .white
    }
    
    func showSelectedColorFromPicker(color: UIColor) {
        colorPickerTile.image = nil
        colorPickerTile.backgroundColor = color
        showCheckIcon(tag: 4)
    }
}

//MARK: - Setup views
/***************************************************************/

extension EditNoteViewController {
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: presenter.titleForSaveButton,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
        
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
        
        titleTextField.text = presenter.note.title
        textTextView.text = presenter.note.content
        firstColorTile.backgroundColor = presenter.note.color
        
        setBorder(for: titleTextField, color: UIColor.gray.withAlphaComponent(0.2), radius: 5)
        setBorder(for: textTextView, color: UIColor.gray.withAlphaComponent(0.3), radius: 5)
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
}

//MARK: - Selector methods
/***************************************************************/

extension EditNoteViewController {
    @objc func saveButtonTapped(_ sender: UIButton) {
        var date: Date? = nil
        if destroyDateSwitch.isOn {
            date = destroyDatePicker.date
        }
        presenter.saveButtonPressed(parameters: EditNoteParameters(title: titleTextField.text,
                                                             content: textTextView.text,
                                                             dateOfSelfDestruction: date))
    }
}

// MARK: - ColorPickerControllerDelegate
/***************************************************************/

extension EditNoteViewController: ColorPickerControllerDelegate {
    func colorPickerController(_ controller: ColorPickerController, willSelect color: UIColor) {
        presenter.colorDidSelectFromPicker(with: color)
    }
}

//MARK: - IBAction
/***************************************************************/

extension EditNoteViewController {
    @IBAction func destroyDateSwitchChanged(_ sender: UISwitch) {
        presenter.useDestroyDateSwitched(state: sender.isOn)
    }
    
    @IBAction func colorTileTapped(_ sender: UIButton) {
        presenter.colorDidSelectFromTile(with: sender.backgroundColor!, tag: sender.tag)
    }
    
    @IBAction func colorPickerLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            presenter.colorPickerLongPressed()
        }
    }
}
