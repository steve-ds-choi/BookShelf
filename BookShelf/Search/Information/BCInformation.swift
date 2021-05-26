//
//  BCInformation.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

enum BCICellType : Int
{
case Normal = 0
case Edit
case Link
}

class BCInformation: BViewController {

    private var _item: BItem!

    private var _details = [String:BCICell]()
    private var _edit    = BCIEdit()
    private var _thumbH  = CGFloat(0)

    @IBOutlet weak var vwTitle:  UIView!
    @IBOutlet weak var lbTitle:  UILabel!
    @IBOutlet weak var vwThumb:  UIView!
    @IBOutlet weak var ivThumb:  UIImageView!
    @IBOutlet weak var vfDetail: MVFold!

    @IBOutlet weak var vsStar:   MVStar!


    func loadStar()
    {
        vsStar.image = UIImage(named:"fb_ico_star")
        vsStar.loadBackgroundBlur()
        vsStar.load()
        vsStar.cornerRadius = 5
    }
    
    override
    func viewDidLoad()
    {
        super.viewDidLoad()

        _thumbH = vwThumb.h
        vfDetail.delegate = self

        loadStar()
    }

    @IBAction
    func btBack(_ sender: UIButton)
    {
        navPop()
    }

    func load(_ item: BItem)
    {
        _item = item
    }

    override
    func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        _item?.remObserver(self)
        _item = nil
    }

    override
    func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        lbTitle.text = _item.title
        _item.addObserver(self)

        _item.rqBody()
        loadItem()
    }

    func get(_ title: String) -> BCICell
    {
        var cell = _details[title]
        if cell == nil
        {
            cell = BCICell()
            cell!.info  = self
            cell!.title = title

            vfDetail.add(cell!.view)
            _details[title] = cell
        }

        return cell!
    }
    
    func set(_ title: String, _ text: String, _ type: BCICellType = .Normal)
    {
        let cell = get(title)
        cell.load(text, type)
    }

    func setEdit(_ title: String, _ text: String)
    {
        let text = text.count == 0 ? " " : text
        set(title, text, .Edit)
    }
    
    func begDetail()
    {
        let thumb = _item.thumb ?? UIImage(named:"acs_ico_photo")
        
        vsStar.rating   = CGFloat(_item.rating)
        ivThumb.image = thumb

        for (_, v) in _details
        {
            v.view.isHidden = true
        }
    }
    
    func endDetail()
    {
        vfDetail.reload()
        vfDetail.contentOffset = CGPoint.zero
    }
    
    func loadItem()
    {
        begDetail()
        
        set("Subtitle",  _item.subtitle)
        set("Price",     _item.price)
        set("Url",       _item.url, .Link)

        set("Authors",   _item.authors)
        set("Publisher", _item.publisher)
        set("Language",  _item.language)
        set("Year",      _item.year)

        set("Isbn10",    _item.isbn10)
        set("Isbn13",    _item.isbn13)

        set("Desc",      _item.desc.decodedHtml)
        
        setEdit("Memo",  _item.memo)

        for (k, v) in _item.pdf
        {
            set(k, v, .Link)
        }

        endDetail()
    }
    
    func onMemoDone()
    {
        let text = _edit.text

        _item.memo = text
        setEdit("Memo", text)

        endDetail()
    }

    func openSub(_ cell: BCICell)
    {
        if cell.title == "Memo"
        {
            _edit.title  = cell.title
            _edit.text   = cell.text.decodedHtml
            _edit.onDone = onMemoDone

            navDetail(_edit)
        }
    }
}

extension BCInformation: UIScrollViewDelegate, IBItem
{
    func observeItem(_ item: BItem) {
        loadItem()
    }

    func scrollViewDidScroll(_ sv: UIScrollView)
    {
        let co = sv.contentOffset
        if co.y < 0 { vwThumb.h = _thumbH - co.y }
    }
}
