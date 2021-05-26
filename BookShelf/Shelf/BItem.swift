//
//  BItem.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

protocol IBItem : NSObjectProtocol
{
    func observeItem(_ item: BItem )
}

class BItem: NSObject {

    private var _obs = [NSObject]()

    var shelf: BShelf!

    var book:  JBook!
    var body:  JBody! {
        didSet {
            desc = body?.desc?.decodedHtml ?? ""
        }
    }

    var desc = ""
    var memo = ""

    weak var thumb: UIImage! {
        didSet {
            if thumb != nil { setObserver() }
        }
    }

    var title      : String { book?.title    ?? "" }
    var subtitle   : String { book?.subtitle ?? "" }
    var isbn13     : String { book?.isbn13   ?? "" }
    var price      : String { book?.price    ?? "" }
    var image      : String { book?.image    ?? "" }
    var url        : String { book?.url      ?? "" }

    var authors    : String { body?.authors   ?? "" }
    var publisher  : String { body?.publisher ?? "" }
    var language   : String { body?.language  ?? "" }
    var isbn10     : String { body?.isbn10    ?? "" }
    var pages      : String { body?.pages     ?? "" }
    var year       : String { body?.year      ?? "" }

    var rating     : Int    { Int(body?.rating ?? "" ) ?? 0 }

    var pdf : [String:String] { body?.pdf ?? [String:String]() }

    init(book: JBook)
    {
        self.book = book
    }

    override init()
    {

    }

    func rqImage()
    {
        shelf.rqImage(self)
    }

    func addObserver(_ ob: IBItem)
    {
        let obj = ob as! NSObject
        _obs.append(obj)

        if thumb != nil {
            ob.observeItem(self)
            return
        }

        shelf.rqImage(self)
    }

    func remObserver(_ ob: IBItem)
    {
        let obj = ob as! NSObject
        _obs.remove(obj)

        shelf.rmImage(self)
    }

    func setObserver()
    {
        _obs.forEach {
            let ob = $0 as! IBItem
            ob.observeItem(self)
        }
    }

    func rqBody()
    {
        if body != nil { return }
        shelf.rqBody(self)
    }
}

