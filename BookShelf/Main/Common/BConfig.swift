//
//  BConfig.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

class BConfig: NSObject {

    var path = ""
    private var _save = 0

    var cacheMax : Int {
        get { conf[#function] as! Int }
        set {
            conf[#function] = newValue
            save()
        }
    }

    var cacheWrite : Bool {
        get { conf[#function] as! Bool }
        set {
            conf[#function] = newValue
            save()
        }
    }

    private var conf = [String:Any]()
 
    private
    func loadDefault()
    {
        conf["cacheMax"] = 20
        conf["cacheWrite"] = false
    }

    func load()
    {
        guard let c = path.toDictionary() else {
            loadDefault()
            return
        }

        conf = c
    }
    
    private
    func save()
    {
        _save += 1
        _ASYNC { self.commit() }
    }
    
    private
    func commit()
    {
        _save -= 1
        if _save > 0 { return }

        path.fwrite(dictionary:conf)
    }
}
