//
//  ColorPickerPresenter.swift
//  Notes
//
//  Created by Natalia Kazakova on 26/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

protocol ColorPickerView: class {
    func showColor(color: UIColor)
}

protocol ColorPickerPresenterDelegate: class {
    func colorPickerPresenter(_ presenter: ColorPickerPresenter, didSelect color: UIColor)
}

protocol ColorPickerPresenter {
    init(view: ColorPickerView, color: UIColor)
    
    func viewDidLoad()
}

class ColorPickerPresenterImpl {
    
    private weak var view: ColorPickerView?
    weak var delegate: ColorPickerPresenterDelegate?
    private var color: UIColor
    
    required init(
        view: ColorPickerView,
        color: UIColor) {
        self.view = view
        self.color = color
    }
}

//MARK: - ColorPickerPresenter
/***************************************************************/

extension ColorPickerPresenterImpl: ColorPickerPresenter {
    func viewDidLoad() {
        view?.showColor(color: color)
    }
}

//MARK: ColorPickerDelegate ColorPickerDelegate
/***************************************************************/

extension ColorPickerPresenterImpl: ColorPickerDelegate {
    func colorPicker(_ colorPicker: ColorPickerViewXIB, willSelectColor color: UIColor) {
        delegate?.colorPickerPresenter(self, didSelect: color)
    }
}
