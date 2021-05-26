//
//  UILabel+Ex.swift
//  BookShelf
//
//  Created by steve on 2021/05/24.
//

import UIKit

extension UILabel {

    private
    func addAttr(_ text: NSMutableAttributedString, _ color: UIColor, _ font: UIFont?, _ range: NSRange)
    {
        text.addAttribute(.foregroundColor, value:color, range: range)

        if font != nil {
            text.addAttribute(.font, value:font!, range:range)
        }
    }
    
    func setSpotText(_ text: String, color: UIColor, font: UIFont?)
    {
        if text.count == 0 { return }

        let attr = NSMutableAttributedString(string: text.replace(of:"\"", with:""))

        var b = -1
        var s = 0

        for i in 0..<text.count {

            if text[i...i] != "\"" { continue }

            if b == -1 {
                b = i - s
            }
            else {
                addAttr(attr, color, font, NSMakeRange(b, i-b-s))
                b = -1
            }

            s += 1
        }

        self.text = nil
        self.attributedText = attr
    }

    func setSpotText(_ text: String, spot: String, color: UIColor, font: UIFont?)
    {
        if text.count == 0 { return }
        if spot.count == 0 {
            self.attributedText = nil
            self.text = text
            return
        }

        let attr  = NSMutableAttributedString(string:text)
        var range = text.range(of:spot, .caseInsensitive)

        while(range.length > 0)
        {
            self.addAttr(attr, color, font, range)

            range = text.range(of:spot,
                               .caseInsensitive,
                               NSMakeRange(range.location+1, text.count - range.location - 1))
        }

        self.text = nil
        self.attributedText = attr
    }

}
