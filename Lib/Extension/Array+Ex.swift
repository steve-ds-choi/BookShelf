//
//  Array+Ex.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

extension Array where Element: Equatable
{
    mutating func remove(_ obj:Element)
    {
        guard let index = firstIndex(of:obj) else { return }
        remove(at:index)
    }

    mutating func remove(arr:Array)
    {
        if arr.count == 0 { return }
        self = filter { !arr.contains($0) }
    }
}
