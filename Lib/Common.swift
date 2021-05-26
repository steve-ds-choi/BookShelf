//
//  Common.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

var __scale   = CGFloat(0)
var __isRound = true
var __insetT  = CGFloat(0)
let __bundle  = Bundle.main

private var _q0:DispatchQueue!
private var _q1:DispatchQueue!
private var _q2:DispatchQueue!

typealias blk0_t = () -> (Void)
typealias blk1_t = (Any?) -> (Void)

func loadHelper()
{
    _q0 = DispatchQueue.main
    _q1 = DispatchQueue(label:"th1")
    _q2 = DispatchQueue(label:"th2")
    
    __scale = UIScreen.main.scale
    
    guard let window = UIApplication.shared.windows.first else { return }

    if #available(iOS 11.0, *) {
        let insets = window.safeAreaInsets
        
        __insetT  = insets.t
        __isRound = insets.b > 0
    }
}

func _TSAFE<T>(_ lock: Any, work: () throws -> T) rethrows -> T
{
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }

    return try work()
}

private
func _BLK(_ blk:DispatchQueue, _ delay:Double = 0, _ work: @escaping blk0_t)
{
    blk.asyncAfter(deadline: .now() + delay)
    {
        work()
    }
}

func _ASYNC(_ delay: Double = 0, work: @escaping blk0_t)
{
    _BLK(_q0, delay, work)
}

func _THREAD1(_ delay: Double = 0, work: @escaping blk0_t)
{
    _BLK(_q1, delay, work)
}

func _THREAD2(_ delay: Double = 0, work: @escaping blk0_t)
{
    _BLK(_q2, delay, work)
}

func _openLink(_ text: String)
{
    let url = text.asURL
    
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:])
    } else {
        UIApplication.shared.openURL(url)
    }
}
