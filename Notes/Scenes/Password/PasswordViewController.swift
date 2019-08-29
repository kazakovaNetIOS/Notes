//
//  PasswordViewController.swift
//  Notes
//
//  Created by Natalia Kazakova on 28/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hintTextField: UITextField!
    
    var configurator: PasswordConfigurator!
    var viewModel: PasswordViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(passwordViewController: self)
        bindViewModel()
        setupViews()
    }
}

//MARK: - Setup views
/***************************************************************/

extension PasswordViewController {
    private func bindViewModel() {
        viewModel.passwordValue.bind { [unowned self] in
            guard let string = $0,
                self.passwordTextField.text != string else { return }
            self.passwordTextField.text = string
        }
        
        viewModel.hintValue.bind { [unowned self] in
            guard let string = $0,
                self.hintTextField.text != string else { return }
            self.hintTextField.text = string
        }
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        passwordTextField.addTarget(self,
                                    action: #selector(textFieldDidChange),
                                    for: UIControl.Event.editingChanged)
        hintTextField.addTarget(self,
                                action: #selector(textFieldDidChange),
                                for: UIControl.Event.editingChanged)
    }
}

//MARK: - Selector methods
/***************************************************************/

extension PasswordViewController {
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.save()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField == passwordTextField {
            viewModel.passwordValue.value = textField.text
        } else if textField == hintTextField {
            viewModel.hintValue.value = textField.text
        }
    }
}
