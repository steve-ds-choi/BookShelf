//
//  BLink.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

typealias blk_list_t = (String, Int, Int, [BItem]) -> (Void)
typealias blk_data_t = (BItem, Data) -> (Void)
typealias blk_body_t = (BItem) -> (Void)

class BLink: NSObject {

    var onListError: blk0_t!

    private var _items = [String:BItem]()
    private var _q_img = [BItem]()

    private var _root = "https://api.itbook.store/1.0/"

    private var _lsTask:  URLSessionDataTask!
    private var _dnTask:  URLSessionDataTask!
    private var _session: URLSession!

    func load()
    {
        let conf = URLSessionConfiguration.default

        conf.timeoutIntervalForRequest  = 10
        conf.timeoutIntervalForResource = 30

        _session = URLSession(configuration: conf)
    }

    func linkList(_ list: JList?) -> [BItem]
    {
        var items = [BItem]()

        guard let books = list?.books else { return items }

        for book in books
        {
            let isbn13 = book.isbn13!

            var item = _items[isbn13]
            if item == nil
            {
                item = BItem(book: book)
                _items[isbn13] = item
            }

            items.append(item!)
        }

        return items
    }

    func onList(_ text: String, _ data: Data?, _ blk: @escaping blk_list_t)
    {
        guard let data = data else { return }

        let json = JSONDecoder()
        var list: JList?

        do {
            list = try json.decode(JList.self, from: data)
        }
        catch {
            print(error)
        }

        let total = Int(list?.total ?? "0")!
        let page  = Int(list?.page  ?? "0")!

        let items = linkList(list)

        _ASYNC {
            blk(text, page, total, items)
        }
    }
    
    func rmList()
    {
        _lsTask?.cancel()
        _lsTask = nil

        _dnTask?.cancel()
        _dnTask = nil

        _q_img.removeAll()
    }
    
    func rqList(_ text: String, _ page: Int, blk: @escaping blk_list_t)
    {
        let uri = _root + "search/" + text.urlQuery + "/" + page.str

        rmList()
        let task = _session.dataTask(with: uri.asURL) { (data, resp, err) in

            if err != nil
            {
                if self._lsTask == nil { return } // cancel - not error

                _ASYNC { self.onListError() }

                return
            }

            if resp == nil { return } // cancel

            self._lsTask = nil
            self.onList(text, data, blk)
        }
        task.resume()

        _lsTask = task
    }

    func onBody(_ item: BItem, _ data: Data?, _ blk: @escaping blk_body_t)
    {
        guard let data = data else { return }

        let json = JSONDecoder()
        var body: JBody?

        do {
            body = try json.decode(JBody.self, from: data)
        }
        catch {
            print(error)
        }

        _ASYNC {
            item.body = body
            blk(item)
        }
    }

    private
    func rsThumbData(_ item: BItem)
    {
        if _q_img.contains(item) == false { return }
        if _dnTask != nil && _q_img.first == item { return }

        _q_img.remove(item)
        _q_img.insert(item, at:1)
    }
    
    func rqBody(_ item: BItem, blk: @escaping blk_body_t)
    {
        rsThumbData(item) // 썸네일 다운로드에 대한 우선순위를 최대한 올린다.

        let uri = _root + "books/" + item.isbn13

        _session.dataTask(with: uri.asURL) { (data, resp, err) in

            if resp == nil { return } // canceld
            self.onBody(item, data, blk)
        }.resume()
    }

    private
    func onThumbData(_ item: BItem, _ data: Data?, _ blk: @escaping blk_data_t)
    {
        guard let data = data else { return }

        _ASYNC {
            self._dnTask = nil
            self._q_img.remove(item)
            blk(item, data)
            self.thumbData(blk)
        }
    }

    private
    func thumbData(_ blk: @escaping blk_data_t)
    {
        if _q_img.count == 0 { return }
        if _dnTask != nil { return }

        let item = _q_img.first!
        let uri  = item.image

        _dnTask =
        _session.dataTask(with: uri.asURL) { (data, resp, err) in

            if resp == nil { return } // canceld
            self.onThumbData(item, data, blk)
        }

        _dnTask.resume()
    }

    func rqThumbData(_ item: BItem, _ blk: @escaping blk_data_t)
    {
        if _q_img.contains(item) == true { return }
        _q_img.append(item)

        thumbData(blk)
    }

    func rmThumbData(_ item: BItem)
    {
        if _dnTask != nil && _q_img.first == item { return } // 다운로드중 이라는거다
        _q_img.remove(item)
    }
}
