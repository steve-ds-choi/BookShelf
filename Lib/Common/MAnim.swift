//
//  MAnim.swift
//  BookShelf
//
//  Created by steve on 2021/05/23.
//

import UIKit

private let ANI_DURATION: TimeInterval = 0.25

class MAnim: NSObject {

    static var DEF_CURVE = 7 // Spring Animation

    static var animate = true
    static var curve = -1
    static var duration = ANI_DURATION
    static var delay: TimeInterval = 0

    static
    func run(_ beg: @escaping blk0_t, end: blk0_t?)
    {
        defer {
            animate  = true
            curve    = -1
            duration = ANI_DURATION
            delay    = 0
        }

        if animate == false
        {
            beg()
            end?()

            return
        }

        duration = duration > 0 ? duration : ANI_DURATION
        curve = curve == -1 ? DEF_CURVE : curve

        let opt = UIView.AnimationOptions(rawValue:UInt(curve << 16))

        UIView.animate(withDuration: duration, delay: delay, options: opt)
        {
            beg()
        }
        completion: { complete in
            end?()
        }
    }

    static
    func run(animate : Bool, _ fn : @escaping blk0_t, end: blk0_t? = nil)
    {
        self.animate = animate
        run(fn, end:end)
    }

    static
    func run(_ duration: TimeInterval, _ beg: @escaping blk0_t, end: blk0_t?)
    {
        self.duration = duration
        self.run(beg, end: end)
    }

    static
    func run(_ beg: @escaping blk0_t)
    {
        self.run(beg, end: nil)
    }

    static
    func run(_ duration: TimeInterval, _ beg: @escaping blk0_t)
    {
        self.run(duration, beg, end: nil)
    }
}
