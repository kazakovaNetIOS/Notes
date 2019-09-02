//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Natalia Kazakova on 21/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorTileView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}

//MARK: - NoteCellView
/***************************************************************/

extension NoteTableViewCell: NoteCellView {
    func display(note: Note) {
        titleLabel?.text = note.title
        contentLabel?.text = note.content
        colorTileView?.backgroundColor = note.color
    }
}

//MARK: - Override methods
extension NoteTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorTileView.layer.borderColor = UIColor.lightGray.cgColor
        colorTileView.layer.borderWidth = 1
        colorTileView.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = colorTileView.backgroundColor
        super.setSelected(selected, animated: animated)
        if selected { colorTileView.backgroundColor = color }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = colorTileView.backgroundColor
        super.setHighlighted(highlighted, animated: true)
        if highlighted { colorTileView.backgroundColor = color }
    }
}
