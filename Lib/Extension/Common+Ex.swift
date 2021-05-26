//
//  Common+Ex.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

fileprivate
func __pi(_ p: CGFloat) -> CGFloat
{
    let s = __scale
    return (round(p * s) / s)
}

extension CGRect {

    init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {

        self.init(x: __pi(x), y: __pi(y), width: __pi(w), height: __pi(h))
    }

    var x: CGFloat {
        get { origin.x }
        set { origin.x = __pi(newValue) }
    }

    var y: CGFloat {
        get { origin.y }
        set { origin.y = __pi(newValue) }
    }

    var w: CGFloat {
        get { size.width }
        set { size.width = __pi(newValue) }
    }

    var h: CGFloat {
        get { size.height }
        set { size.height = __pi(newValue) }
    }

    var wx: CGFloat { w + x }
    var hy: CGFloat { h + y }
}

extension CGSize {

    init(_ w: CGFloat, _ h: CGFloat) {
        self.init(width: __pi(w), height: __pi(h))
    }

    var w: CGFloat {
        get { width }
        set { width = __pi(newValue) }
    }

    var h: CGFloat {
        get { height }
        set { height = __pi(newValue) }
    }
}

extension CGPoint {
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: __pi(x), y: __pi(y))
    }
}

extension UIEdgeInsets
{
    var t: CGFloat { top }
    var l: CGFloat { left }
    var b: CGFloat { bottom }
    var r: CGFloat { right }
}

extension UIImage {

    var w: CGFloat {
        get { size.width }
    }

    var h: CGFloat {
        get { size.height }
    }
}

extension UITableView {
    
    func dequeueReusableCell(_ identifier : String) -> UITableViewCell? {
        var cell = dequeueReusableCell(withIdentifier:identifier)

        if cell == nil {
            let nib = __bundle.loadNibNamed(identifier, owner:self, options:nil)
            cell = nib?[0] as? UITableViewCell
        }

        return cell
    }
}

extension Int
{
    var str: String { "\(self)"}
}

extension Bool
{
    var intValue: Int       { self ? 1 : 0 }
    var floatValue: CGFloat { CGFloat(intValue)}
}

extension IndexPath
{
    var r: Int { row }
    var s: Int { section }
}
