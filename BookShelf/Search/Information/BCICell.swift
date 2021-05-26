//
//  BCICell.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

class BCICell: BViewController {

    var link = false
    var sw   = CGFloat(0)
    
    var info : BCInformation!
    var type = BCICellType.Normal

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbText:  UILabel!

    func loadType()
    {
        var color = UIColor.lightGray

        if #available(iOS 13.0, *) {
            color = .label
        }

        lbText.textColor = type == .Link ? .rgb(0, 122, 255) : color

        if type == .Edit
        {
            lbText.cornerRadius = 7
            lbText.layer.borderWidth = 1
            lbText.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    func load(_ text: String, _ type: BCICellType)
    {
        self.text = text
        self.type = type

        view.isHidden = text.count == 0

        lbTitle.text = title
        lbText.text  = text

        view.w = view.superview!.w

        var size = lbText.frame.size
        size = lbText.sizeThatFits(size)

        view.h = (size.h + 14)

        loadType()
    }
    
    @IBAction
    func btCell(_ sender: UIButton)
    {
        switch type {
        case .Link: _openLink(text)
        case .Edit: info.openSub(self)
        default:
            break
        }
    }

}
