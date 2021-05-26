//
//  BCBCell.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

class BCBCell: UITableViewCell {

    private var _item: BItem!

    @IBOutlet weak var lbTitle:    UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var ivThumb:    UIImageView!

    func load(_ item: BItem, _ spot: String)
    {
        _item = item

        if item.thumb == nil
        {
            ivThumb.image = UIImage(named:"acs_ico_photo")
        }

        let color = UIColor.rgb(238, 130, 238)

        lbTitle.setSpotText(_item.title, spot: spot, color: color, font: nil)
        lbSubtitle.setSpotText(_item.subtitle, spot: spot, color: color, font: nil)

        _item.addObserver(self)
    }
    
    func unload()
    {
        lbTitle.text = nil
        lbSubtitle.text = nil
        ivThumb.image = nil

        _item?.remObserver(self)
        _item = nil
    }
}

extension BCBCell: IBItem
{
    func observeItem(_ item: BItem) { ivThumb.image = item.thumb }
}
