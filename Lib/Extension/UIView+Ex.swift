//
//  UIView+Ex.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

extension UIView.AutoresizingMask {

    private static let _MASK:(UInt) -> UIView.AutoresizingMask = { UIView.AutoresizingMask(rawValue:$0) }

    static let MA = _MASK(0x12) // all
    static let MC = _MASK(0x2d) // center
    static let MP = _MASK(0x2d) // popup
    static let MF = _MASK(0x3f) // full

    static let MN = _MASK(0)
    static let ML = _MASK(0x14)
    static let MR = _MASK(0x11)
    static let MT = _MASK(0x22)
    static let MB = _MASK(0x0a)
    static let MM = _MASK(0x2a) // MH

    static let MLT = _MASK(0x24) // left top flexible
}

extension UIView {

    var rd: NSString {
        value(forKey: "recursiveDescription") as! NSString
    }

    var rs: [UIView] {
        subviews + subviews.flatMap { $0.rs }
    }

    var x: CGFloat {
        get { frame.x }
        set { frame.x = newValue }
    }

    var y: CGFloat {
        get { frame.y }
        set { frame.y = newValue }
    }

    var w: CGFloat {
        get { frame.w }
        set { frame.w = newValue }
    }

    var h: CGFloat {
        get { frame.h }
        set { frame.h = newValue }
    }

    var wx: CGFloat { frame.wx }
    var hy: CGFloat { frame.hy }

    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius  = newValue
            layer.masksToBounds = true
        }
    }

    func move(_ x: CGFloat, _ y: CGFloat) {
        frame.origin = CGPoint(x, y)
    }

    func resize(_ w: CGFloat, _ h: CGFloat) {
        frame.size = CGSize(w, h)
    }
    
    func layout(oh:CGFloat, oy:CGFloat = 0)
    {
        var rect = frame

        rect.h += oh
        rect.y += oy

        frame = rect
    }
    
    func layout(ow:CGFloat, ox:CGFloat = 0)
    {
        var rect = frame

        rect.w += ow
        rect.x += ox

        frame = rect
    }

    func loadBackgroundBlur(_ style: UIBlurEffect.Style = .extraLight)
    {
        backgroundColor = .clear
        let blur = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: blur)
        view.frame = bounds
        view.autoresizingMask = .MF
        insertSubview(view, at: 0)
    }
}
