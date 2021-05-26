//
//  BShelf.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

protocol IBShelfList
{
    func shelf(_ shelf: BShelf, onList  list: [BItem])
    func shelf(_ shelf: BShelf, onBody  item: BItem)
    func shelf(_ shelf: BShelf, onImage item: BItem)
    func shelf(_ shelf: BShelf, onListError text: String?)
}

class BShelf: NSObject
{
    var list = [BItem]()
    var delegate: IBShelfList!
    var total = 0

    var cache: BCache!

    private var _reqPage = 0
    private var _curPage = 0

    private let _link   = BLink()
    private var _text   = ""
    private var _retry  = 3
    
    func load(_ cache: BCache)
    {
        if self.cache != nil { return }

        self.cache = cache
        _link.load()

        _link.onListError = onListError
    }
    
    func onListError()
    {
        var text: String?

        if _retry > 0 // 오류 발생시 _retry 만큼 시도해 본다
        {
            text = _text

            _retry -= 1
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(reList), with: nil, afterDelay: 1)
        }

        delegate?.shelf(self, onListError:text)
    }

    func onList(_ text:String, _ page: Int, _ total: Int, _ items: [BItem])
    {
        _retry = 3
        if total == 0
        {
            delegate?.shelf(self, onList: list)
            return
        }

        if _text    != text { return }
        if _reqPage != page { return }

        _curPage = _reqPage
        self.total = total

        items.forEach { $0.shelf = self }

        list += items
        delegate?.shelf(self, onList: list)

        if list.count < total { rqNext() } // 잔여가 남아 있으니 자동으로 다음 리스트를 호출한다.
    }

    @objc
    func reList()
    {
        rqList(text: _text)
    }

    func rqList(text: String)
    {
        list.removeAll()

        total = 0

        _reqPage = 0
        _curPage = 0

        _text = text

        if text.count == 0
        {
            _link.rmList()
            delegate?.shelf(self, onList: list)
            return
        }

        rqNext()
    }
    
    @discardableResult
    func rqNext() -> Bool
    {
        if _text.count == 0    { return false }
        if _reqPage > _curPage { return false }

        _reqPage += 1

        _link.rqList(_text, _reqPage) { (text, page, total, items) in
            self.onList(text, page, total, items)
        }
        return true
    }

    func rqBody(_ item: BItem)
    {
        _link.rqBody(item) {
            $0.setObserver()
            self.delegate.shelf(self, onBody:$0)
        }
    }

    func onImage(_ item: BItem, _ data: Data)
    {
        let thumb = cache.add(item.isbn13, data: data)
        item.thumb = thumb

        delegate.shelf(self, onImage:item)
    }
    
    func rqImage(_ item: BItem)
    {
        let thumb = cache.get(item.isbn13)

        if thumb != nil {
            item.thumb = thumb
            return
        }

        _link.rqThumbData(item, onImage)
    }
    
    func rmImage(_ item: BItem)
    {
        _link.rmThumbData(item)
    }
}
