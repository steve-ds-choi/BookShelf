//
//  MVFold.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

public
class MVFold: UIScrollView {

    var nofit  = false
    var vgap   = CGFloat(0)

    func initialize()
    {
        alwaysBounceHorizontal         = false
        alwaysBounceVertical           = true
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
    }

    override public
    func awakeFromNib() {
        initialize()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        initialize()
    }

//////////////////////
    func resetContentSize(_ v: UIView) -> Bool
    {
        if isScrollEnabled == false { return false }

        var size = contentSize

        size.w = w
        size.h = v.hy
        if size.h < self.h { size.h = self.h }

        contentSize = size

        return true
    }

    func isHidden(_ v: UIView) -> Bool
    {
        if v.isHidden == true { return true }
        if v.alpha == 0       { return true }
        if v.isUserInteractionEnabled == false { return true }

        return false
    }
    
    func lastSubview() -> UIView?
    {
        let subs = subviews.reversed()
        var v: UIView?

        for s in subs
        {
            if isHidden(s) == true { continue }
            v = s
        }

        return v
    }

//////////////////////
    func add(_ v: UIView)
    {
        v.autoresizingMask = .MT
        insertSubview(v, at:0)
    }
    
    func reload()
    {
        if subviews.count == 0 { return }
        let subs = subviews.reversed()

        let w = self.w, h = self.h
        var y = CGFloat(0)
        var v : UIView!
        var f = CGRect.zero

        for s in subs
        {
            if isHidden(s) == true { continue }

            v = s

            f = CGRect(0, y, w, s.h)

            v.frame = f

            y += s.h
            y += vgap
        }

        if v == nil { return }
        if resetContentSize(v) == true { return }

        if nofit == true { return }
        if v.y > h { return }

        f = v.frame
        f.h = h - f.y

        v.frame = f
        v.autoresizingMask = .MA
    }    
}
