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
    var router: ColorPickerRouter { get }
    func viewDidLoad()
}

class ColorPickerPresenterImpl {
    
    private weak var view: ColorPickerView?
    private(set) var router: ColorPickerRouter
    private weak var delegate: ColorPickerPresenterDelegate?
    private var color: UIColor
    
    init(
        view: ColorPickerView,
        router: ColorPickerRouter,
        delegate: ColorPickerPresenterDelegate?,
        color: UIColor) {
        self.view = view
        self.router = router
        self.delegate = delegate
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
