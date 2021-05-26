//
//  BCache.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

class BCache: NSObject {

    var save = false
    var path = ""
    var max  = 20 {
        didSet {
            remLast()
        }
    }

    var count : Int { _indexs.count }
    var files : Int {
        let count = path.fcount()
        return count == 0 ? 0 : count - 1
    }

    private var _req = 0

    private var _images = [String:UIImage]()
    private var _indexs = [String]()
    private var _pathIndexs = ""

    func contains(_ uid: String) -> Bool { _images[uid] != nil }

    func load()
    {
        path.fcreate()
        _pathIndexs = path.pmake("indexs")

        if save == false { return }

        guard let indexs = _pathIndexs.toArray() as? [String] else { return }

        indexs.reversed().forEach {

            let path  = self.path.pmake($0)
            let image = path.toImage()

            _indexs.insert($0, at:0)
            _images[$0] = image
        }

        remLast()
    }

    private
    func _save()
    {
        if save == false { return }
        _req += 1

        _ASYNC { self._commit() }
    }

    private
    func _commit(_ now: Bool = false)
    {
        if now == false
        {
            _req -= 1
            if _req > 0 { return }
        }

        _TSAFE(self)
        {
            _pathIndexs.fwrite(array: _indexs)
        }
    }

    private
    func fwrite(_ uid: String, _ data: Data)
    {
        if save == false { return }

        let path = path.pmake(uid)
        path.fwrite(data: data)
    }

    private
    func fremove(_ uid: String)
    {
        if save == false { return }

        let path = path.pmake(uid)
        path.fremove()
    }

    private
    func remLast()
    {
        let k = _indexs.count - max
        if k <= 0 { return }

        for _ in 0..<k
        {
            let uid = _indexs.last!
            rem(uid)
        }

        _save()
    }

    func clrImages()
    {
        _TSAFE(self)
        {
            if _indexs.count == 0 { return }

            _indexs.removeAll()
            _images.removeAll()
        }
    }

    func clrFiles()
    {
        if save == false { return }

        _TSAFE(self)
        {
            path.fcreate(2)
        }
        
        _save()
    }

    func clrAll()
    {
        clrImages()
        clrFiles()
    }

    func set(_ uid: String)
    {
        _TSAFE(self)
        {
            if contains(uid) == false { return }

            _indexs.remove(uid)
            _indexs.insert(uid, at:0)
        }

        _save()
    }
    
    @discardableResult
    func add(_ uid: String, data: Data?) -> UIImage?
    {
        guard let data = data else { return nil }

        return _TSAFE(self)
        {
            var image = _images[uid]
            if image == nil
            {
                image = UIImage(data:data)
                if image == nil { return nil }

                _images[uid] = image
                fwrite(uid, data)
            }

            defer {
                remLast()
            }

            return get(uid)
        }
    }
    
    func rem(_ uid: String)
    {
        _TSAFE(self)
        {
            if contains(uid) == false { return }

            _indexs.remove(uid)
            _images.removeValue(forKey: uid)

            fremove(uid)
        }
    }
    
    func get(_ uid: String) -> UIImage?
    {
        return _TSAFE(self)
        {
            if contains(uid) == false { return nil }

            set(uid)
            let image = _images[uid]

            return image
        }
    }
    
    func commitAll()
    {
        path.fcreate(2)

        if save == false { return }

        defer {
            _commit(true)
        }

        var i = 0
        for (k, v) in _images
        {
            if i >= max { return }
            let data = v.pngData()
            
            if data == nil { continue }
            fwrite(k, data!)
            
            i += 1
        }
    }
    
}
